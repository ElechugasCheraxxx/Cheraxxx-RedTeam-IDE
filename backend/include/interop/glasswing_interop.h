#ifndef GLASSWING_INTEROP_H
#define GLASSWING_INTEROP_H

#include <stdint.h>
#include <stddef.h>

/**
 * @brief Estándar de Interoperabilidad de Capa Cero para GLASSWING.
 * Todas las fronteras FFI (Rust, Go, Zig, C++) deben usar estas estructuras.
 */

#ifdef __cplusplus
extern "C" {
#endif

// Identificador único de misión para rastreo políglota (Tactic 5)
typedef uint64_t MissionID;

// Estado de retorno universal para evitar discrepancias de tipos
typedef enum {
    GW_SUCCESS = 0,
    GW_ERROR_MEMORY_FAULT = 1,
    GW_ERROR_CIPHER_FAILURE = 2,
    GW_ERROR_NETWORK_TIMEOUT = 3,
    GW_ERROR_ACCESS_DENIED = 4,
    GW_ERROR_VERIFICATION_FAILED = 5
} GW_Status;

// Buffer de memoria compartida (Zero-Copy Tactic 1)
typedef struct {
    uint8_t* data;
    size_t length;
    size_t capacity;
    MissionID mission_id;
} GW_SharedBuffer;

// Firma de la función de liberación (Ownership Handover)
typedef void (*GW_FreeBufferFn)(GW_SharedBuffer* buffer);

/**
 * @brief Ejemplo de interfaz para el módulo Cipher (Rust)
 * Verificado formalmente en backend/proofs/cipher_integrity.v
 */
GW_Status gw_cipher_encrypt(MissionID id, const GW_SharedBuffer* plaintext, GW_SharedBuffer* ciphertext);
GW_Status gw_cipher_decrypt(MissionID id, const GW_SharedBuffer* ciphertext, GW_SharedBuffer* plaintext);

#ifdef __cplusplus
}
#endif

#endif // GLASSWING_INTEROP_H
