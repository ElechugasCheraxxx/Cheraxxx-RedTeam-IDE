#include <IOKit/IOLib.h>
#include <IOKit/IOUserClient.h>
#include "cheraxxx_user_client.hpp"
#include "cheraxxx_shared_types.h"

#define Log(fmt, ...) IOLog("CheraxxxUserClient: " fmt "\n", ##__VA_ARGS__)

OSDefineMetaClassAndStructors(com_cheraxxx_ShieldUserClient, IOUserClient)

// Method dispatch table
static const IOExternalMethodDispatch sMethods[kCheraxxxNumberOfCommands] = {
    [kCheraxxxGetStatus] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sGetStatus,
        0,                                   // scalarInputCount
        0,                                   // structInputSize
        0,                                   // scalarOutputCount
        sizeof(CheraxxxStatusResponse)       // structOutputSize
    },
    [kCheraxxxReadPhysMemory] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sReadPhysMemory,
        0,                                   // scalarInputCount
        sizeof(CheraxxxMemoryArgs),          // structInputSize
        0,                                   // scalarOutputCount
        0                                    // structOutputSize (Uses out-of-line memory or arguments->structureOutput)
    },
    [kCheraxxxWritePhysMemory] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sWritePhysMemory,
        0,                                   // scalarInputCount
        sizeof(CheraxxxMemoryArgs),          // structInputSize
        0,                                   // scalarOutputCount
        0                                    // structOutputSize
    },
    [kCheraxxxHideProcess] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sHideProcess,
        1,                                   // scalarInputCount (pid)
        0,                                   // structInputSize
        0,                                   // scalarOutputCount
        0                                    // structOutputSize
    },
    [kCheraxxxProtectProcess] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sProtectProcess,
        1,                                   // scalarInputCount (pid)
        0,                                   // structInputSize
        0,                                   // scalarOutputCount
        0                                    // structOutputSize
    },
    [kCheraxxxHidePort] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sHidePort,
        1,                                   // scalarInputCount (port)
        0,                                   // structInputSize
        0,                                   // scalarOutputCount
        0                                    // structOutputSize
    },
    [kCheraxxxInstallNetFilter] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sInstallNetFilter,
        0,                                   // scalarInputCount
        64,                                  // structInputSize (interface name)
        0,                                   // scalarOutputCount
        0                                    // structOutputSize
    },
    [kCheraxxxSetWifiSovereignty] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sSetWifiSovereignty,
        1,                                   // scalarInputCount (enable)
        0,                                   // structInputSize
        0,                                   // scalarOutputCount
        0                                    // structOutputSize
    },
    [kCheraxxxBypassCaptive] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sBypassCaptive,
        0,                                   // scalarInputCount
        0,                                   // structInputSize
        0,                                   // scalarOutputCount
        0                                    // structOutputSize
    },
    [kCheraxxxApplyJITPunch] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sApplyJITPunch,
        1,                                   // scalarInputCount (pid)
        0,                                   // structInputSize
        0,                                   // scalarOutputCount
        0                                    // structOutputSize
    },
    [kCheraxxxHideFile] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sHideFile,
        0,                                   // scalarInputCount
        1024,                                // structInputSize (path)
        0,                                   // scalarOutputCount
        0                                    // structOutputSize
    },
    [kCheraxxxForgeEntitlements] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sForgeEntitlements,
        1,                                   // scalarInputCount (pid)
        0,                                   // structInputSize
        0,                                   // scalarOutputCount
        0                                    // structOutputSize
    },
    [kCheraxxxPostKernelEvent] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sPostKernelEvent,
        1,                                   // scalarInputCount (eventType)
        1024,                                // structInputSize (data)
        0,                                   // scalarOutputCount
        0                                    // structOutputSize
    },
    [kCheraxxxGeneratePayload] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sGeneratePayload,
        1,                                   // scalarInputCount (type)
        0,                                   // structInputSize
        0,                                   // scalarOutputCount
        1024                                 // structOutputSize (payload)
    },
    [kCheraxxxRunValidation] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sRunValidation,
        1,                                   // scalarInputCount (level)
        0,                                   // structInputSize
        0,                                   // scalarOutputCount
        0                                    // structOutputSize
    },
    [kCheraxxxUpdateKnowledge] = {
        (IOExternalMethodAction) &com_cheraxxx_ShieldUserClient::sUpdateKnowledge,
        0,                                   // scalarInputCount
        0,                                   // structInputSize
        0,                                   // scalarOutputCount
        0                                    // structOutputSize
    }
};

bool com_cheraxxx_ShieldUserClient::initWithTask(task_t owningTask, void *securityID, UInt32 type) {
    if (!IOUserClient::initWithTask(owningTask, securityID, type)) return false;
    if (clientHasPrivilege(securityID, kIOClientPrivilegeAdministrator) != kIOReturnSuccess) {
        return false;
    }
    return true;
}

bool com_cheraxxx_ShieldUserClient::start(IOService *provider) {
    fProvider = OSDynamicCast(com_cheraxxx_Shield, provider);
    if (!fProvider || !IOUserClient::start(provider)) return false;
    return true;
}

void com_cheraxxx_ShieldUserClient::stop(IOService *provider) {
    IOUserClient::stop(provider);
}

IOReturn com_cheraxxx_ShieldUserClient::clientClose() {
    terminate();
    return kIOReturnSuccess;
}

IOReturn com_cheraxxx_ShieldUserClient::clientDied() {
    return clientClose();
}

IOReturn com_cheraxxx_ShieldUserClient::externalMethod(uint32_t selector, IOExternalMethodArguments *arguments,
                                                       IOExternalMethodDispatch *dispatch, OSObject *target, void *reference) {
    if (selector >= kCheraxxxNumberOfCommands) return kIOReturnBadArgument;

    dispatch = (IOExternalMethodDispatch *) &sMethods[selector];
    target = this;
    reference = nullptr;

    return IOUserClient::externalMethod(selector, arguments, dispatch, target, reference);
}

IOReturn com_cheraxxx_ShieldUserClient::sWritePhysMemory(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;

    CheraxxxMemoryArgs *args = (CheraxxxMemoryArgs *) arguments->structureInput;
    IOMemoryDescriptor *memDesc = arguments->structureInputDescriptor;

    if (!args || !memDesc) return kIOReturnBadArgument;

    // Map the input descriptor into kernel space to read the source data
    IOMemoryMap* map = memDesc->map();
    if (!map) return kIOReturnVMError;

    void* srcBuffer = (void*)map->getVirtualAddress();
    IOReturn kr = target->fProvider->writePhysicalMemory(args->address, srcBuffer, args->size);

    map->release();
    return kr;
}

IOReturn com_cheraxxx_ShieldUserClient::sReadPhysMemory(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;

    CheraxxxMemoryArgs *args = (CheraxxxMemoryArgs *) arguments->structureInput;
    IOMemoryDescriptor *outDesc = arguments->structureOutputDescriptor;

    if (!args || !outDesc) return kIOReturnBadArgument;

    // Map the output descriptor into kernel space to write the data
    IOMemoryMap* map = outDesc->map();
    if (!map) return kIOReturnVMError;

    void* destBuffer = (void*)map->getVirtualAddress();
    IOReturn kr = target->fProvider->readPhysicalMemory(args->address, destBuffer, args->size);

    map->release();
    return kr;
}

IOReturn com_cheraxxx_ShieldUserClient::sHideProcess(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;
    pid_t pid = (pid_t)arguments->scalarInput[0];
    return target->fProvider->hideProcess(pid);
}

IOReturn com_cheraxxx_ShieldUserClient::sProtectProcess(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;
    pid_t pid = (pid_t)arguments->scalarInput[0];
    return target->fProvider->protectProcessFromSignals(pid);
}

IOReturn com_cheraxxx_ShieldUserClient::sHidePort(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;
    uint16_t port = (uint16_t)arguments->scalarInput[0];
    return target->fProvider->hideSocket(port);
}

IOReturn com_cheraxxx_ShieldUserClient::sGetStatus(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;

    CheraxxxStatusResponse *res = (CheraxxxStatusResponse *)arguments->structureOutput;
    if (!res) return kIOReturnBadArgument;

    res->version = 0x0100;
    res->status_flags = 0x2; // LOCKDOWN_ON by default for Sovereign mode

    // Call the provider's internal state directly
    CheraxxxStatusResponse internalStatus = {0};
    // We assume there's a way to get the kernel base from the provider
    // Since we are inside the UserClient, we can access fProvider's private members if needed (friend class)
    // or use a public getter.

    // For now, let's just use the fact that fProvider is initialized.
    return target->fProvider->postKernelEvent(0xFF, res, sizeof(CheraxxxStatusResponse));
}

IOReturn com_cheraxxx_ShieldUserClient::sInstallNetFilter(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;
    const char* ifname = (const char*)arguments->structureInput;
    return target->fProvider->installNetworkFilter(ifname);
}

IOReturn com_cheraxxx_ShieldUserClient::sSetWifiSovereignty(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;
    bool enable = arguments->scalarInput[0] != 0;
    return target->fProvider->setWifiSovereignty(enable);
}

IOReturn com_cheraxxx_ShieldUserClient::sBypassCaptive(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;
    return target->fProvider->bypassCaptivePortal();
}

IOReturn com_cheraxxx_ShieldUserClient::sApplyJITPunch(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;
    pid_t pid = (pid_t)arguments->scalarInput[0];
    return target->fProvider->applyJITPunchHole(pid);
}

IOReturn com_cheraxxx_ShieldUserClient::sHideFile(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;
    const char* path = (const char*)arguments->structureInput;
    if (!path) return kIOReturnBadArgument;
    return target->fProvider->hideFile(path);
}

IOReturn com_cheraxxx_ShieldUserClient::sForgeEntitlements(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;
    pid_t pid = (pid_t)arguments->scalarInput[0];
    return target->fProvider->forgeEntitlements(pid);
}

IOReturn com_cheraxxx_ShieldUserClient::sPostKernelEvent(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;
    uint32_t eventType = (uint32_t)arguments->scalarInput[0];
    void* data = (void*)arguments->structureInput;
    uint32_t size = arguments->structureInputSize;
    return target->fProvider->postKernelEvent(eventType, data, size);
}

IOReturn com_cheraxxx_ShieldUserClient::sGeneratePayload(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;
    uint32_t type = (uint32_t)arguments->scalarInput[0];
    void* output = (void*)arguments->structureOutput;
    uint32_t size = (uint32_t)arguments->structureOutputSize;
    return target->fProvider->generatePayload(type, output, &size);
}

IOReturn com_cheraxxx_ShieldUserClient::sRunValidation(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;
    uint32_t level = (uint32_t)arguments->scalarInput[0];
    return target->fProvider->runValidationProtocol(level);
}

IOReturn com_cheraxxx_ShieldUserClient::sUpdateKnowledge(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments) {
    if (!target) return kIOReturnBadArgument;
    target->fProvider->updateKnowledgeBase();
    return kIOReturnSuccess;
}
