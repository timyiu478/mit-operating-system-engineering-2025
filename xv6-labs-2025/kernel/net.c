#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "fs.h"
#include "sleeplock.h"
#include "file.h"
#include "net.h"

#define MAX_PORT_SIZE (3 << 16)
#define PACKET_BUF_SIZE 16

struct rx_ring {
  uint64 buf_addr[PACKET_BUF_SIZE]; // packet address array
  uint r;  // Read index
  uint w;  // Write index
};

// a map of port -> binded status
// if process id == true, it means this port is binded
// otherwise, the port is NOT binded
static bool port2Status[MAX_PORT_SIZE];

// a map of port id to rx_ring
static struct rx_ring port2Ring[MAX_PORT_SIZE];

// xv6's ethernet and IP addresses
static uint8 local_mac[ETHADDR_LEN] = { 0x52, 0x54, 0x00, 0x12, 0x34, 0x56 };
static uint32 local_ip = MAKE_IP_ADDR(10, 0, 2, 15);

// qemu host's ethernet address.
static uint8 host_mac[ETHADDR_LEN] = { 0x52, 0x55, 0x0a, 0x00, 0x02, 0x02 };

static struct spinlock netlock;

void
netinit(void)
{
  initlock(&netlock, "netlock");

  // initialise unbinded ports and rx_rings
  for (int i=0; i< MAX_PORT_SIZE; i++){
    port2Status[i] = false;
    port2Ring[i].r = 0;
    port2Ring[i].w = 0;
  }
}


//
// bind(int port)
// prepare to receive UDP packets address to the port,
// i.e. allocate any queues &c needed.
//
uint64
sys_bind(void)
{
  //
  // Your code here.
  //

  int port;
  argint(0, &port);

  if (port < 0) { // invalid port?
    printf("bind: port should >= 0\n");
    return -1;
  }

  acquire(&netlock);

  if (port2Status[port]) { // binded?
    printf("bind: port %d is already binded\n", port);
    return 0;
  }

  struct proc *p = myproc();

  int emptyIdx = -1;
  for (int i =0; i < MAXBPORTS; i++) {
    if (p->bindedports[i] == port) { 
      printf("bind: port %d is binded by pid %d\n", port, p->pid);
      release(&netlock);
      return -1;
    } else if (p->bindedports[i] == -1) {
      emptyIdx = i;
      break;
    }
  }

  if (emptyIdx == -1) {
    printf("bind: unable to bind more than %d number of ports\n", MAXBPORTS);
    release(&netlock);
    return -1;
  }

  // bind port
  p->bindedports[emptyIdx] = port;
  port2Status[port] = true;

  release(&netlock);

  return 0;
}

//
// unbind(int port)
// release any resources previously created by bind(port);
// from now on UDP packets addressed to port should be dropped.
//
uint64
sys_unbind(void)
{
  //
  // Optional: Your code here.
  //

  int port;
  argint(0, &port);

  // invalid port
  if (port < 0) {
    return -1;
  }

  struct proc *p = myproc();

  acquire(&netlock);

  // unbind port
  for (int i =0; i < MAXBPORTS; i++) {
    if (p->bindedports[i] == port) { 
      p->bindedports[i] = -1;
      break;
    }
  }
  port2Status[port] = false;

  // free the queue
  while (port2Ring[port].r != port2Ring[port].w) {
    kfree((void *)port2Ring[port].buf_addr[port2Ring[port].r]);
    port2Ring[port].r = (port2Ring[port].r + 1) % PACKET_BUF_SIZE;
  }

  release(&netlock);

  return 0;
}

//
// recv(int dport, int *src, short *sport, char *buf, int maxlen)
// if there's a received UDP packet already queued that was
// addressed to dport, then return it.
// otherwise wait for such a packet.
//
// sets *src to the IP source address.
// sets *sport to the UDP source port.
// copies up to maxlen bytes of UDP payload to buf.
// returns the number of bytes copied,
// and -1 if there was an error.
//
// dport, *src, and *sport are host byte order.
// bind(dport) must previously have been called.
//
uint64
sys_recv(void)
{
  //
  // Your code here.
  //

  // printf("sys_recv start\n");

  struct proc *p = myproc();
  int dport;
  uint64 src;
  uint64 sport;
  uint64 buf;
  int maxlen;

  argint(0, &dport);
  argaddr(1, &src);
  argaddr(2, &sport);
  argaddr(3, &buf);
  argint(4, &maxlen);

  // Check if the port is binded by the caller
  bool isbinded = false;
  for (int i =0; i < MAXBPORTS; i++) {
    if (p->bindedports[i] == dport) { 
      isbinded = true;
      break;
    }
  }
  if (!isbinded) {
    printf("dport %d is not binded by pid %d\n", dport, p->pid);
    return -1;
  }

  acquire(&netlock);

  struct rx_ring *ring = &port2Ring[dport];

  // Wait until interrupt handler has put some
  // packets into ring->buf_addr.
  while(ring->r == ring->w){
    if(killed(myproc())){
      release(&netlock);
      return -1;
    }
    // printf("sys_recv: sleep, port %d, chan %p\n", dport, &ring->r);
    sleep(&ring->r, &netlock);
  }

  struct eth *ineth = (struct eth *) ring->buf_addr[ring->r];
  struct ip *inip = (struct ip *) (ineth + 1);
  struct udp *inudp = (struct udp *) (inip + 1);
  char *payload = (char *) ((char *)inudp + 8); // 8 byte UDP header

  int ip_src = ntohl(inip->ip_src);
  short udp_sport = ntohs(inudp->sport);

  // Advance the read pointer
  ring->r = (ring->r + 1) % PACKET_BUF_SIZE;

  release(&netlock);

  if (copyout(p->pagetable, src, (char *)&ip_src, sizeof(int)) == -1) {
    goto err;
  }
  if (copyout(p->pagetable, sport, (char *)&udp_sport, sizeof(short)) == -1) {
    goto err;
  }

  uint16 copyLen = ntohs(inudp->ulen) - 8;
  if (copyLen > maxlen) {
    copyLen = (uint16) maxlen;
  }

  // Copy packet to user address space
  if (copyout(p->pagetable, buf, payload, copyLen) == -1) {
    goto err;
  }

  // Free the packet
  kfree(ineth);

  // printf("sys_recv end\n");

  return copyLen;

err:
  kfree(ineth);
  return -1;

}

// This code is lifted from FreeBSD's ping.c, and is copyright by the Regents
// of the University of California.
static unsigned short
in_cksum(const unsigned char *addr, int len)
{
  int nleft = len;
  const unsigned short *w = (const unsigned short *)addr;
  unsigned int sum = 0;
  unsigned short answer = 0;

  /*
   * Our algorithm is simple, using a 32 bit accumulator (sum), we add
   * sequential 16 bit words to it, and at the end, fold back all the
   * carry bits from the top 16 bits into the lower 16 bits.
   */
  while (nleft > 1)  {
    sum += *w++;
    nleft -= 2;
  }

  /* mop up an odd byte, if necessary */
  if (nleft == 1) {
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    sum += answer;
  }

  /* add back carry outs from top 16 bits to low 16 bits */
  sum = (sum & 0xffff) + (sum >> 16);
  sum += (sum >> 16);
  /* guaranteed now that the lower 16 bits of sum are correct */

  answer = ~sum; /* truncate to 16 bits */
  return answer;
}

//
// send(int sport, int dst, int dport, char *buf, int len)
//
uint64
sys_send(void)
{
  struct proc *p = myproc();
  int sport;
  int dst;
  int dport;
  uint64 bufaddr;
  int len;

  argint(0, &sport);
  argint(1, &dst);
  argint(2, &dport);
  argaddr(3, &bufaddr);
  argint(4, &len);

  int total = len + sizeof(struct eth) + sizeof(struct ip) + sizeof(struct udp);
  if(total > PGSIZE)
    return -1;

  char *buf = kalloc();
  if(buf == 0){
    printf("sys_send: kalloc failed\n");
    return -1;
  }
  memset(buf, 0, PGSIZE);

  struct eth *eth = (struct eth *) buf;
  memmove(eth->dhost, host_mac, ETHADDR_LEN);
  memmove(eth->shost, local_mac, ETHADDR_LEN);
  eth->type = htons(ETHTYPE_IP);

  struct ip *ip = (struct ip *)(eth + 1);
  ip->ip_vhl = 0x45; // version 4, header length 4*5
  ip->ip_tos = 0;
  ip->ip_len = htons(sizeof(struct ip) + sizeof(struct udp) + len);
  ip->ip_id = 0;
  ip->ip_off = 0;
  ip->ip_ttl = 100;
  ip->ip_p = IPPROTO_UDP;
  ip->ip_src = htonl(local_ip);
  ip->ip_dst = htonl(dst);
  ip->ip_sum = in_cksum((unsigned char *)ip, sizeof(*ip));

  struct udp *udp = (struct udp *)(ip + 1);
  udp->sport = htons(sport);
  udp->dport = htons(dport);
  udp->ulen = htons(len + sizeof(struct udp));

  char *payload = (char *)(udp + 1);
  if(copyin(p->pagetable, payload, bufaddr, len) < 0){
    kfree(buf);
    printf("send: copyin failed\n");
    return -1;
  }

  e1000_transmit(buf, total);

  return 0;
}

void
ip_rx(char *buf, int len)
{
  // don't delete this printf; make grade depends on it.
  static int seen_ip = 0;
  if(seen_ip == 0)
    printf("ip_rx: received an IP packet\n");
  seen_ip = 1;

  //
  // Your code here.
  //

  // printf("ip_rx: start\n");

  struct eth *ineth = (struct eth *) buf;
  struct ip *inip = (struct ip *) (ineth + 1); // advance the pointer by 1 × sizeof(struct eth) bytes
  struct udp *inudp = (struct udp *) (inip + 1);

  if ( (ntohl(inip->ip_dst) != local_ip)    // check if the dst IP is equal to host IP
    || (inip->ip_p != IPPROTO_UDP)          // check if the arriving packet is UDP
    || (!port2Status[ntohs(inudp->dport)])  // its destination port has been passed to bind()
      ) {
    // drop the packet
    kfree(buf);
    return;
  }

  acquire(&netlock);

  struct rx_ring *ring = &port2Ring[ntohs(inudp->dport)];

  // Drop the packet if the queue is fulled
  if ((ring->w + 1) % PACKET_BUF_SIZE == ring->r) {
    kfree(buf);
    release(&netlock);
    return;
  }

  // Put the packet into the queue
  ring->buf_addr[ring->w] = (uint64) buf;
  ring->w = (ring->w + 1) % PACKET_BUF_SIZE;
  
  release(&netlock);

  // Wake up sys_recv()
  // printf("wake up port %d, chan %p\n", ntohs(inudp->dport), &ring->r);
  wakeup(&ring->r);

  // printf("ip_rx: end\n");
}

//
// send an ARP reply packet to tell qemu to map
// xv6's ip address to its ethernet address.
// this is the bare minimum needed to persuade
// qemu to send IP packets to xv6; the real ARP
// protocol is more complex.
//
void
arp_rx(char *inbuf)
{
  static int seen_arp = 0;

  if(seen_arp){
    kfree(inbuf);
    return;
  }
  printf("arp_rx: received an ARP packet\n");
  seen_arp = 1;

  struct eth *ineth = (struct eth *) inbuf;
  struct arp *inarp = (struct arp *) (ineth + 1);

  char *buf = kalloc();
  if(buf == 0)
    panic("send_arp_reply");
  
  struct eth *eth = (struct eth *) buf;
  memmove(eth->dhost, ineth->shost, ETHADDR_LEN); // ethernet destination = query source
  memmove(eth->shost, local_mac, ETHADDR_LEN); // ethernet source = xv6's ethernet address
  eth->type = htons(ETHTYPE_ARP);

  struct arp *arp = (struct arp *)(eth + 1);
  arp->hrd = htons(ARP_HRD_ETHER);
  arp->pro = htons(ETHTYPE_IP);
  arp->hln = ETHADDR_LEN;
  arp->pln = sizeof(uint32);
  arp->op = htons(ARP_OP_REPLY);

  memmove(arp->sha, local_mac, ETHADDR_LEN);
  arp->sip = htonl(local_ip);
  memmove(arp->tha, ineth->shost, ETHADDR_LEN);
  arp->tip = inarp->sip;

  e1000_transmit(buf, sizeof(*eth) + sizeof(*arp));

  kfree(inbuf);
}

void
net_rx(char *buf, int len)
{
  struct eth *eth = (struct eth *) buf;

  if(len >= sizeof(struct eth) + sizeof(struct arp) &&
     ntohs(eth->type) == ETHTYPE_ARP){
    arp_rx(buf);
  } else if(len >= sizeof(struct eth) + sizeof(struct ip) &&
     ntohs(eth->type) == ETHTYPE_IP){
    ip_rx(buf, len);
  } else {
    kfree(buf);
  }
}
