/**
 * @file    master.ma
 * @brief   philae master assembly placeholder - prints "Hello World", exits 0
 * @why     The project's master assembly must exist, build from machine-code
 *          assembly, and run end-to-end from day zero. This placeholder
 *          proves the toolchain, the .ma comment convention, and the run
 *          path in one minimal unit.
 * @syntax  GNU as (AT&T), x86-64, Linux syscall ABI, no libc
 * @build   as -o /tmp/master.o master.ma && ld -e _start -o /tmp/master /tmp/master.o
 * @run     /tmp/master  ->  stdout: "Hello World"
 * @exit    0
 * @agent   .ma comment convention (master assembly, JSDoc-like):
 *          - Doc blocks sit above every symbol/section; @brief (what) and
 *            @why (reasoning) are MANDATORY.
 *          - Optional tags: @in/@out (state contract), @agent (notes for
 *            machine readers), @see; file-header-only: @syntax/@build/@run/@exit.
 *          - Inline doc comments after an instruction clarify one line;
 *            # line comments carry mechanical notes; reasoning lives in @why.
 *          - Em dashes (U+2014) are strictly forbidden in comments and code:
 *            use ASCII hyphens or rephrase.
 *          Agents MUST keep @brief/@why truthful when editing.
 */

.file "master.ma"
.global _start
.section .text

/**
 * @brief   Program entry: one write(2) syscall, then exit(2)
 * @why     Raw syscalls keep the binary static and dependency-free - the
 *          kernel is the only service provider. A placeholder benefits
 *          from an explicit, auditable runtime contract; libc/crt0 would
 *          add preamble this program does not use.
 * @in      (none)
 * @out     fd 1 (stdout) receives "Hello World\n" (12 bytes); exit status 0
 */
_start:
    mov $1, %rax          # syscall number 1 = write
    mov $1, %rdi          # fd 1 = stdout
    lea msg(%rip), %rsi   # buffer; RIP-relative = position-independent, no relocation
    mov $12, %rdx         # length: 12 bytes ("Hello World\n")
    syscall               # @why kernel boundary: bytes written are returned in %rax
    mov $60, %rax         # syscall number 60 = exit
    xor %rdi, %rdi        # status 0
    syscall               # @agent no ret here - exit(2) never returns; do not fall through

.section .rodata

/**
 * @brief   The payload written to stdout
 * @why     Exactly "Hello World\n": the acceptance string is fixed, and the
 *          trailing newline keeps output line-oriented for automated checks.
 * @in      (none)
 * @out     read-only; address consumed by the lea in _start
 */
msg:
    .ascii "Hello World\n"

/* non-executable stack marker: silences ld's executable-stack warning */
.section .note.GNU-stack,"",@progbits
