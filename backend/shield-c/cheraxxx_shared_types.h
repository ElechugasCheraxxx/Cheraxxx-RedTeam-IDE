#ifndef CHERAXXX_SHARED_TYPES_H
#define CHERAXXX_SHARED_TYPES_H

enum CheraxxxCommandID {
    kCheraxxxGetStatus          = 0,
    kCheraxxxHideProcess        = 1,
    kCheraxxxReadPhysMemory     = 2,
    kCheraxxxWritePhysMemory    = 3,
    kCheraxxxSetStealthMode     = 4,
    kCheraxxxProtectProcess     = 5,
    kCheraxxxHidePort           = 6,
    kCheraxxxInstallNetFilter   = 7,
    kCheraxxxSetWifiSovereignty = 8,
    kCheraxxxBypassCaptive      = 9,
    kCheraxxxApplyJITPunch      = 10,
    kCheraxxxHideFile           = 11,
    kCheraxxxForgeEntitlements   = 12,
    kCheraxxxPostKernelEvent    = 13,
    kCheraxxxGeneratePayload    = 14,
    kCheraxxxRunValidation      = 15,
    kCheraxxxUpdateKnowledge    = 16,
    kCheraxxxNumberOfCommands
};

struct CheraxxxStatusResponse {
    uint32_t version;
    uint32_t status_flags; // bit 0: SIP_OFF, bit 1: LOCKDOWN_ON
    uint64_t kernel_base;
};

struct CheraxxxMemoryArgs {
    uint64_t address;
    uint64_t size;
};

// Mach IPC payload type (synchronized with cheraxxx_ipc.defs)
typedef char tact_msg_payload_t[1024];

#endif
