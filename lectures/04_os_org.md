Monolithic OS Design:

- more code => more bugs
+ sub modules are tightly coupled and live in the same program => high performance

---

Mirco kernel: remove some kernel sub-modules (e.g. file system) or move them to user-space

- more syscalls when the process need to interact with many user-space "kernel sub-modules" => lower performance
