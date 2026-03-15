// Mutual exclusion lock.
struct spinlock {
  uint locked;       // Is the lock held?

  // For debugging:
  char *name;        // Name of lock.
  struct cpu *cpu;   // The cpu holding the lock.
#ifdef LAB_LOCK
  int nts;
  int n;
#endif
};

#ifdef LAB_LOCK
#define WRITER_BIT (1L << 63)
#define PENDING_BIT (1L << 62)

// Reader-writer lock.
struct rwspinlock {
  uint64 state;
};
#endif
