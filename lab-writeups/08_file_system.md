# Lab: file system

## Details

See https://pdos.csail.mit.edu/6.1810/2025/labs/fs.html

## DEMOS

* **Large File**: https://docs.google.com/videos/d/1NIcR-zV4cCmgmZ7kHkol9t9qudfgKRsyLyGBViHnaaI/play
* **Symbolic Links**: https://docs.google.com/videos/d/1GCia9tGPXOqcluuHb-fkk7WnXEdCzp8Yl0q4dmNfocs/play

---

## Large File

### Related source code

See 

### Design Choices

* Use the page table approach to index the doubly-indrect block and the indirect blocks it points to.
    * index of the doubly-indrect block = logical block number / NINDIRECT
    * index of the indirect block it points to = logical block number % NINDIRECT

### Mistakes I made

* forgot to change the addr[] of struct inode
* typos and they were caught by AI nicely!

---

## Symbolic Links

### Related source code

See

### Design Choices

* Store the target path of the symbolic link in the inode's data block.
* Open system call: return -1 if the depth of links reaches some threshold (e.g., 10).
    * The depth of links increases by one for each symbolic link it follows

### Mistakes I made

* Missing transaction: file system modifications (ialloc, dirlink, writei, iupdate) must be inside a transaction

---

## Key Takeaways

* Indirect block is not inode. Indirect blocks are stored in regular data blocks.
* How to map file offset to the correct disk block
* Open system call: the relationships of inode, file, and file descriptor
    * ip = namex(path)
    * f = falloc()
    * fdalloc(f): p->ofile[fd] = f 
    * set f: e.g. f->ip = ip
