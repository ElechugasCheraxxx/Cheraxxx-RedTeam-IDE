#pragma once

#include <cstdint>

extern "C" {
    /**
     * @brief Invocación directa de syscalls ARM64 saltando los hooks de LibSystem.
     * @param number Número de syscall (X16).
     * @return Resultado de la syscall o -errno.
     */
    long direct_syscall(long number, ...);

    /**
     * @brief Limpieza segura de registros volátiles y no volátiles.
     * Utilizado tras operaciones criptográficas o antes de retornar de un stub de evasión.
     */
    void clear_registers_secure();

    /**
     * @brief Obtiene el contador virtual (ARM64) para timing de alta resolución.
     */
    uint64_t get_nanoseconds_arm();

    /**
     * @brief Aceleración NEON para la acumulación de estados RDT.
     */
    void rdt_neon_hop_accel(float* states, const float* residual, float decay, uint32_t count);
}
