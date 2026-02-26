# Riscv-v vs x86

risc-v:

* + fewer and simpler instructions
* + open source
* - less powerful instructions => use more instructions to achieve higher-level operations

Why x86 has so many instructions? Intel is very concerned about backward compatibility.

---

## Assembly Language

Q. What is .global?

.global makes the symbol visible to ld. If you define symbol in your partial program, its value is made available to other partial programs that are linked with it. Otherwise, symbol takes its attributes from a symbol of the same name from another file linked into the same program.

Ref: https://sourceware.org/binutils/docs/as/Global.html

---

## Calling Convention

Caller Save vs Callee Save:

* Caller Save:
    * does NOT preserve across function calls
    * save rule: caller must save and restore a caller-save register before/after the call only if the caller needs its value to **persist across the call**.
* Callee Save:
    * preserve across function calls
    * save rule: callee must save and restore a callee-save register only if **the callee modifies (uses) it**

Why is RA(return address) caller-save?

* RA does not preserve across function calls.
* If the callee makes further nested calls, it needs change the RA so that the nested calls can return correctly.
* But this makes callee lose the RA of its caller.
* Thus, it to save the RA into the memory first before changing RA to callee's return address.


Refs:

* https://pdos.csail.mit.edu/6.1810/2025/readings/riscv-calling.pdf
* https://csg.csail.mit.edu/6.S983/recs/riscv_recitation/

---

## GDB

New Commands that I learnt:

* focus
* watchpoints
* conditional break
