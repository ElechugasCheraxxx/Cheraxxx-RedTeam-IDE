.section __TEXT,__text,regular,pure_instructions
.macosx_version_min 14, 0
.p2align 2

/*
 * extern "C" long direct_syscall(long number, ...);
 * x0: syscall number
 * x1-x7: arguments
 */
.global _direct_syscall
_direct_syscall:
    mov x16, x0             // Syscall number in x16
    mov x0, x1              // Shift arguments: arg0 was in x1
    mov x1, x2              // arg1 was in x2
    mov x2, x3              // arg2 was in x3
    mov x3, x4              // arg3 was in x4
    mov x4, x5              // arg4 was in x5
    mov x5, x6              // arg5 was in x6
    mov x6, x7              // arg6 was in x7

    svc #0x80               // Supervisor Call
    b.cs _syscall_error     // Check Carry Flag for error
    ret

_syscall_error:
    neg x0, x0              // Return -errno
    ret

/*
 * extern "C" void clear_registers_secure();
 * Wipes all general purpose registers to prevent forensic recovery of keys/data.
 */
.global _clear_registers_secure
_clear_registers_secure:
    mov x0, #0
    mov x1, #0
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0
    mov x8, #0
    mov x9, #0
    mov x10, #0
    mov x11, #0
    mov x12, #0
    mov x13, #0
    mov x14, #0
    mov x15, #0
    mov x16, #0
    mov x17, #0
    // Skip x18 (platform register), x29 (fp), x30 (lr)
    mov x19, #0
    mov x20, #0
    mov x21, #0
    mov x22, #0
    mov x23, #0
    mov x24, #0
    mov x25, #0
    mov x26, #0
    mov x27, #0
    mov x28, #0
    ret

/*
 * extern "C" uint64_t get_nanoseconds_arm();
 * Uses the virtual counter (CNTVCT_EL0) for high-precision timing checks.
 * Essential for detecting debugger stepping or VM latencies.
 */
.global _get_nanoseconds_arm
_get_nanoseconds_arm:
    isb                     // Instruction Synchronization Barrier
    mrs x0, cntvct_el0      // Read Virtual Count register
    ret

/*
 * extern "C" void rdt_neon_hop_accel(float* states, const float* residual, float decay, uint32_t count);
 * Optimized NEON kernel for RDT activation accumulation.
 * hidden_states[id] = (hidden_states[id] * decay) + residual[id];
 */
.global _rdt_neon_hop_accel
_rdt_neon_hop_accel:
    // x0: states (float*)
    // x1: residual (const float*)
    // s0: decay (float)
    // w2: count (uint32_t)

    cbz w2, .Ldone          // if count == 0, return

    dup v0.4s, v0.s[0]           // Duplicate decay factor into NEON register

.Lloop:
    cmp w2, #4
    b.lt .Lremainder

    ld1 {v1.4s}, [x0]        // Load 4 hidden states
    ld1 {v2.4s}, [x1], #16   // Load 4 residuals, post-increment x1

    fmul v1.4s, v1.4s, v0.4s // hidden * decay
    fadd v1.4s, v1.4s, v2.4s // (hidden * decay) + residual

    st1 {v1.4s}, [x0], #16   // Store back, post-increment x0
    sub w2, w2, #4
    b .Lloop

.Lremainder:
    cbz w2, .Ldone
    ldr s1, [x0]
    ldr s2, [x1], #4
    fmadd s1, s1, s0, s2     // Scalar fused multiply-add: s1 = s1 * s0 + s2
    str s1, [x0], #4
    sub w2, w2, #1
    b .Lremainder

.Ldone:
    ret
