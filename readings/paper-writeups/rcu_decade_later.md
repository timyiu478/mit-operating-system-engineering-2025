---
title: "RCU Usage In the Linux Kernel: One Decade Later"
description: 
tags: ["Synchronization", "Linux", "Parallelism"]
---

# Takeaways


# Motivations



# Overall Design


---

# Details

---

# Questions

Q. Figure 8 shows the performance of acquiring a read-write lock for reading. The read-write lock's implementation is similar to the one you implemented in the lab. Looking at your read_acuire implementation and the overhead shown in Figure 8 in the paper, what operation in your implementation becomes more expensive as more cores acquire the lock in parallel in read mode?




---

# Why I read this paper

* RCU is everywhere in Linux
    * https://elixir.bootlin.com/linux/v6.19.11/source/fs/dcache.c#L366
    * https://elixir.bootlin.com/linux/v6.19.11/source/drivers/net/ethernet/mellanox/mlxsw/core.c#L2971


# Further Study

