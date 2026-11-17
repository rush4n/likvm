# HW2 answers

Fill in this file and hand it in with your code (your HW1 answers stay
in answers.md). Replace each
`(your answer)` with two or three sentences. Keep the question numbers
(part.question), and do not delete the questions.

- **Name:** Rushan Shaikh
- **Machine and environment you tested on** (CADE lab machine with QEMU, or Bochs): local linux machine with QEMU 10.0.13
- **How far did you get?** (for example "the guest boots to a shell", or "stuck in part 4"): the guest boots to a shell (successfully) finally!


## Part 1: The host side: what changes in xv6 itself

### Question 1.1

> What is the largest file, in blocks and in bytes, that xv6 can hold with the layout of Step 4? How many disk blocks does `xv6fs.img` (1,024,000 bytes) occupy as a file in `fs.img`, counting its pointer blocks? How large could a file be if `BSIZE` were 1024 bytes instead of 512?

**Answer:** The largest file is 16,396 blocks or 8,394,752 bytes (about 8 MB). xv6fs.img is 1,024,000 bytes (2000 blocks). With BSIZE 1024, the maximum is 12 + 256×256 = 65,548 blocks, or 67,121,152 bytes.

### Question 1.2

> Suppose someone changes `GUESTMEM` in `runxv6.c` to 16 MB and forgets the Makefile. What happens when the guest boots, at about which guest-physical address, and why? What happens in the opposite case (`GUESTMEM` 64 MB, `PHYSTOP` still 32 MB)?

**Answer:** kinit1() would walk up through memory and, at the first page past 16 MB, touch a guest-physical address the EPT does not map. The CPU exits with an EPT violation, and runxv6 stops with guest touched unmapped guest-physical 0x2000000. The opposite mistake (a PHYSTOP smaller than GUESTMEM) is harmless: the guest simply never uses the rest.

### Question 1.3

> `runxv6` must pass your keystrokes to the guest while it keeps the guest running. Explain why it needs *both* `fdready()` and `consraw()`: what would go wrong with `fdready()` alone (console still in line mode), and what would go wrong with `consraw()` alone (no `fdready()`)?

**Answer:** With fdready() alone and the console in line mode, the host would echo your keys, so every key shows twice. With only consraw(), runxv6 would have to call read() with nothing typed, so it would sleep and the guest would freeze.

### Question 1.4

> Why did we turn `addrs[12]` into a doubly-indirect block instead of adding a 14th address to the inode? Give one advantage the classic 11 direct + singly-indirect + doubly-indirect layout has over ours, and explain why the difference matters little in practice.

**Answer:** A 14th address would make struct dinode 68 bytes, so 512/68 = 7.5 inodes per block and inodes would straddle block boundaries, which IBLOCK() and IPB arithmetic does not handle. A file between about 6 KB and 70 KB (blocks 11 to 138) needs only one pointer block, while in our layout any file past 12 blocks needs two, the doubly-indirect block and its first indirect block. It costs one extra disk block per such file and, on a cold cache, one extra block read per bmap().

### Question 1.5

> The Makefile builds the guest kernel's objects in `guest/` instead of next to the host kernel's. Describe what could go wrong, step by step, if both kernels were built in the same directory, and which kernel would end up broken.

**Answer:** Because make decides what to rebuild only by comparing timestamps. kalloc.o built for the host and kalloc.o built for the guest have the same name and the same sources, so make cannot tell them apart: after building one kernel, it would consider the other one’s objects up to date, and quietly link a guest kernel with the host’s PHYSTOP (or the reverse).


## Part 2: Reading and writing guest memory

### Question 2.1

> `gva2gpa()` tests bit 7 (`PS`) of the entry only at the PDPT and PD levels. What does bit 7 mean in a PML4 entry and in a page-table entry (SDM Tables 5-15 and 5-20)? Describe a concrete guest mapping that a walk testing `PS` at every level would translate wrongly, and what it would return.

**Answer:** In a PT entry bit 7 is PAT, a caching attribute (Table 5-20), and in a PML4 entry it is reserved (Table 5-15). If you test it at every level, a 4 KB page with PAT set is taken for a large page. So it would stop at the PT level and build the address with a 21-bit offset from the wrong bits of the entry. The result would be a wrong guest-physical address.

### Question 2.2

> `gva2gpa()` reads every page-table entry through `gpa2kva()`, that is, through the EPT. Why can it not use `P2V()` on the table address, as xv6's own `walkpglevel()` (in `vm.c`) does for its page tables? Which memory would `P2V(table)` read? How does the CPU solve the same problem when the guest itself accesses memory (SDM 31.3.1)?

**Answer:** Because guest-physical address 0x100000 is not host-physical address 0x100000. P2V(0x100000) is the host kernel’s own code. Every guest-physical address must go through the EPT. The CPU solves this in hardware using guest paging-structure.

### Question 2.3

> xv6's IDE driver reads a sector with `insl(0x1f0, b->data, BSIZE/4)`, 512 bytes into `b->data`. Suppose `b->data` starts 256 bytes before the end of a guest page. Describe, iteration by iteration, what `vmmem()` does with this request. Why would one translation followed by one 512-byte `memmove()` be wrong, even though the guest kernel maps its data to consecutive guest-physical pages?

**Answer:** The first iteration translates the address and copies 256 bytes, the remainder of the first page, and the second iteration translates addr + 256 again and copies the other 256 bytes into the next page.

### Question 2.4

> `vmrun()` saves `GUEST_CR3` into `vm->cr3` after every exit. Why can `vmmem()` not simply call `vmread(GUEST_CR3)` when it needs the value? And why is the saved value never out of date when `vmmem()` uses it?

**Answer:** By the time vmmem() runs, vmrun() has executed VMCLEAR, which makes the current-VMCS pointer invalid, so VMREAD would fail. The copies are never stale when vmmem() uses them. A process in xv6 has one thread, and while it is in vmmem() it is not in vmrun(), so the guest is not running and its registers cannot change. runxv6 handles an exit and then calls vmmem(): it sees the registers of exactly the exit it is handling.


## Part 3: Booting xv6 in a VM

### Question 3.1

> Before Step 1, the exception bitmap was all ones. Suppose you had
> kept it that way for the xv6 guest. What would happen the first
> time a user program in the guest dereferences a null pointer, and
> what would the hypervisor have to do to make the guest behave
> exactly as on a real machine? Why does `INT $64` not raise the
> same issue?

**Answer:** With every bit set, the exception would exit to the hypervisor instead of reaching the guest’s handler, and the hypervisor would have to inject it back into the guest (SDM 29.6), paying for a VM exit every time. With the bitmap 0, the CPU delivers every exception through the guest’s IDT, as on a real machine, and the hypervisor never hears about it. The INT $64 is a software interrupt, not an exception, and the exception bitmap does not apply to it at all.

### Question 3.2

> `CPUID` causes a VM exit unconditionally, while instructions such
> as `HLT` exit only if the VMCS asks for it (SDM 28.1.2 and 28.1.3).
> Why would a CPU designer make `CPUID` always exit? Use what you
> did in Step 3 as an example, and give one more reason a
> hypervisor might want to change what the guest sees.

**Answer:** CPUID always exit becuase we do not want the guest to know what a CPU can do. In Step 3, we hide the  VMX bit so the guest does not try to use nested virtualization.

### Question 3.3

> `loadkernel()` copies each segment to `p_paddr`. What would happen,
> exactly, if it used `p_vaddr` instead? And what would go wrong if
> `vmcreate()` did not zero guest memory, given that `loadkernel()`
> copies only `filesz` bytes of each segment?

**Answer:** Copying to vaddr would not even work: 0x80000100000 is far outside the guest’s 32 MB. If vmcreate() did not zero guest memory, the bss would hold junk.

### Question 3.4

> Your MP table describes one processor with APIC id 0. (a) If its
> APIC id were 1, where exactly would the guest stop, and why would
> you see no message? (b) Suppose instead you listed two processors,
> with ids 0 and 1. Read `startothers()` in `main.c` and
> `lapicstartap()` in `lapic.c`: what would the guest do, and why
> can our zeroed APIC page never make it work?

**Answer:** (a) With APIC id 1, mycpu() would look up the id the guest reads from its zeroed local APIC page, which is 0, find no match in cpus[], and panic with “unknown apicid”.

## Part 4: Interrupts

### Question 4.1

> `nextpending()` delivers the highest pending vector first. Which
> rule of a local APIC does this imitate (SDM 13.8.3), and what does a
> real local APIC also take into account that we ignore? With the timer
> (32) and the disk (46) both pending, which goes first, and what happens
> to a second timer tick that arrives before the guest has taken the
> first?

**Answer:** That is what a local APIC does. SDM 13.8.3: the priority class of an interrupt is bits 7:4 of its vector, and within a class, the higher bits 3:0 win. A real local APIC would also compare with its task priority register (TPR) and with the vector in service (ISR) and hold lower-priority interrupts back until the handler’s EOI. We have neither, so the vector order is all the priority we model. with the timer (32) and the disk (46) pending, the disk goes first.

### Question 4.2

> Rule 1 of `vmxinject()` re-injects an event whose delivery was
> interrupted by a VM exit. For each of (a) a timer interrupt we injected,
> (b) a page fault raised by a guest instruction, (c) an `int $64` system
> call: is the event lost if we do not re-inject it, and why? For (c),
> what goes wrong if we re-inject it but forget the instruction length?

**Answer:** (a) The timer interrupt is lost. It's pending bit was cleared when we injected it and the original-event identification is now its only record. (b) a page fault, or (c) an INT $64 system call is not lost: the guest’s RIP still points at the instruction that raised it, so when the guest resumes, the instruction runs again and raises the event again. With length forgotten (i.e. 0), the handler’s iretq returns to the INT itself, and the guest makes the system call twice.

### Question 4.3

> Why must `vmrun()` return to user space once per host tick?
> Describe what the guest would do, and what you would see at the
> terminal, if it returned only on I/O and HLT exits while the guest sits
> at an idle shell prompt and you type a key. Why not return on every
> external-interrupt exit instead?

**Answer:** It is because runxv6 gets to run at least once per tick. If vmrun() returned only on I/O or HLT, a guest computing in a loop would get no timer interrupts (no preemption, no sleep() wakeups) and no typed keys.Returning on every host interrupt would also work, but would cost a trip to user space each time.

### Question 4.4

> Why does `vmxinject()` not inject an external interrupt when
> the guest has `RFLAGS.IF = 0`? Give two reasons: one from the VM-entry
> checks, one from what xv6 is doing when IF is 0. Why is waiting for the
> next exit of any kind not good enough, so that we need interrupt-window
> exiting?

**Answer:** (a) VM entry itself refuses an injected external interrupt when RFLAGS.IF is 0 (SDM 29.3.1.4). (b) The guest scheduler holds ptable.lock with IF = 0 while scanning the process table. The guest spends most of its time with IF = 0, so a pending interrupt would wait for an exit, and interrupt-window exiting makes the CPU exit at exactly the first moment the guest can take one.

### Question 4.5

> Our guest has one CPU. List what the hypervisor and `runxv6`
> would need in order to give it two. Think about the local APIC ID each
> CPU reads from the same guest-physical page, how xv6 starts the second
> CPU (`lapicstartap()`), where each interrupt should go, the VMCS, and
> the fact that an xv6 process has a single thread.

**Answer:** Each CPU would need its own APIC ID, so the APIC page needs to be emulated. Since xv6 has only one thread, the second CPU would also need its own thread to run it.


## Part 5: Devices and string I/O

### Question 5.1

> With our design, reading one 512-byte sector costs one VM exit for
> the data instead of 128. Explain why the kernel can advance RIP past a
> `rep insl` that has not executed a single iteration. What would the kernel
> and `runxv6` have to do differently if `runxv6` moved only one dword per
> exit?

**Answer:** runxv6 moves all count * size bytes at once and then leaves the registers exactly as the CPU would have at the end of the instruction, so the kernel can advance RIP past the instruction. The kernel would leave RIP alone, so the CPU would re-execute the REP instruction and exit again for the remaining iterations.

### Question 5.2

> Suppose a guest executed `std` before `rep insl` (DF = 1). What
> would the CPU do with RDI, and which bytes of memory would it fill? What
> would our `idestring()` do instead? Sketch the change that would handle
> it (which register tells you DF, and how would the address and the RDI
> update change?).

**Answer:** With DF = 1, the CPU would do RDI -= 4. It would fill memory downward from the starting address. idestring() would check DF bit in the guests RFLAGS, copy the buffer ending at the start address, and subtract from RDI.

### Question 5.3

> The guest's keys arrive as serial input, never as PS/2 keyboard
> interrupts. Why is the serial port the natural choice here? What would
> `runxv6` need in order to emulate the keyboard instead (which ports,
> which vector, and what would it have to do to each character)?

**Answer:** T he host xv6 itself gets your keys through its serial port: under make qemu-nox or make bochs-nox the terminal is connected to the emulated PC’s COM1, so runxv6 gets characters from the host’s console. Emulating the PS/2 keyboard instead would need ports 0x60, 0x64, IRQ 1, and translating each kbdintr() scancodes into characters.

### Question 5.4

> Nobody displays the guest's VGA memory at 0xB8000, and yet the
> guest's output is complete. Why? And why, even so, do the CRT controller's
> two ports have to be emulated?

**Answer:** It is because consputc() calls uartputc('l') and then cgaputc('l'), which reads the cursor again, gets 0xFFFF again, and panics again. The CRT controller's two ports have to be emulated because cgaputc() writes 14 to port 0x3D4 and reads the high byte of the position from 0x3D5, then does the same with register 15 for the low byte. With no device at 0x3D5, both reads return 0xFF, the position is 0xFFFF, and cgaputc() panics. Each nested panic prints one more l, until the kernel stack overflows and the guest triple-faults.

### Question 5.5

> `struct vmexit` has no field that names a device: there is nothing
> like "disk read" or "serial write". Where does the knowledge that port
> 0x1F0 is a disk live, and why is it better there than in the kernel? Name
> the matching pieces in KVM and QEMU.

**Answer:** runxv6’s doio() decides that, with a switch on the port number. This keeps the kernel small. KVM reports KVM_EXIT_IO with a port number, and QEMU knows which device model lives at that port.
