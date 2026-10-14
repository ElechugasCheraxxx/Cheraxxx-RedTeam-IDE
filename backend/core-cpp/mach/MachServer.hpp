#pragma once
#include <mach/mach.h>

namespace cheraxxx::mach {
    bool StartMachServer();
    mach_port_t GetServerPort();
}
