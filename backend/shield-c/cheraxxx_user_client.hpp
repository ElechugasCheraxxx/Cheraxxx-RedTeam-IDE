#include <IOKit/IOUserClient.h>
#include "cheraxxx_shield.hpp"

class com_cheraxxx_ShieldUserClient : public IOUserClient {
    OSDeclareDefaultStructors(com_cheraxxx_ShieldUserClient);

public:
    virtual bool initWithTask(task_t owningTask, void *securityID, UInt32 type) override;
    virtual bool start(IOService *provider) override;
    virtual void stop(IOService *provider) override;
    virtual IOReturn clientClose() override;
    virtual IOReturn clientDied() override;

    virtual IOReturn externalMethod(uint32_t selector, IOExternalMethodArguments *arguments,
                                    IOExternalMethodDispatch *dispatch, OSObject *target, void *reference) override;

    // Static dispatchers for external methods
    static IOReturn sGetStatus(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);
    static IOReturn sReadPhysMemory(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);
    static IOReturn sWritePhysMemory(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);
    static IOReturn sHideProcess(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);
    static IOReturn sProtectProcess(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);
    static IOReturn sHidePort(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);
    static IOReturn sInstallNetFilter(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);
    static IOReturn sSetWifiSovereignty(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);
    static IOReturn sBypassCaptive(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);
    static IOReturn sApplyJITPunch(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);
    static IOReturn sHideFile(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);
    static IOReturn sForgeEntitlements(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);
    static IOReturn sPostKernelEvent(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);
    static IOReturn sGeneratePayload(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);
    static IOReturn sRunValidation(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);
    static IOReturn sUpdateKnowledge(com_cheraxxx_ShieldUserClient *target, void *reference, IOExternalMethodArguments *arguments);

protected:
    com_cheraxxx_Shield *fProvider;
};
