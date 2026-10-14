#pragma once
#include <cstdint>
#include <cstddef>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

// Estructuras coincidentes con Rust (layout C)
typedef struct {
    uint8_t* pk;
    size_t pk_len;
    uint8_t* sk;
    size_t sk_len;
} PqcKeyPair;

typedef struct {
    uint8_t* ct;
    size_t ct_len;
    uint8_t* ss;
    size_t ss_len;
} PqcEncapsulation;

typedef struct {
    uint8_t* sig;
    size_t sig_len;
} PqcSignature;

// ML-KEM-768 (Kyber)
PqcKeyPair rust_mlkem768_keygen();
void rust_mlkem768_free_keypair(PqcKeyPair kp);
PqcEncapsulation rust_mlkem768_encapsulate(const uint8_t* pk_ptr, size_t pk_len);
uint8_t* rust_mlkem768_decapsulate(const uint8_t* ct_ptr, size_t ct_len, const uint8_t* sk_ptr, size_t sk_len);
void rust_mlkem768_free_encapsulation(PqcEncapsulation res);
void rust_mlkem768_free_buffer(uint8_t* ptr, size_t len);

// ML-DSA-65 (Dilithium)
PqcKeyPair rust_mldsa65_keygen();
void rust_mldsa65_free_keypair(PqcKeyPair kp);
PqcSignature rust_mldsa65_sign(const uint8_t* msg_ptr, size_t msg_len, const uint8_t* sk_ptr, size_t sk_len);
void rust_mldsa65_free_signature(PqcSignature sig);
bool rust_mldsa65_verify(const uint8_t* msg_ptr, size_t msg_len, const uint8_t* sig_ptr, size_t sig_len, const uint8_t* pk_ptr, size_t pk_len);

#ifdef __cplusplus
}
#endif
