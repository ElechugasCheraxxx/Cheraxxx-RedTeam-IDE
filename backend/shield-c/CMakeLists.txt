# Cheraxxx RedTeam IDE - Kernel Shield Build Configuration
cmake_minimum_required(VERSION 3.20)
project(CheraxxxShield)

# 1. Kernel-specific Compilation Guards
# These flags are CRITICAL to prevent Kernel Panics due to unsupported C++ features.
set(KERNEL_FLAGS
    -fno-builtin
    -fno-exceptions
    -fno-rtti
    -fno-common
    -fno-stack-protector
    -mkernel
    -nostdinc++
    -DKERNEL
    -DAPPLE
    -DNeXT
)

add_library(CheraxxxShield OBJECT
    cheraxxx_shield.cpp
    cheraxxx_user_client.cpp
    cheraxxx_log.cpp
)

target_compile_options(CheraxxxShield PRIVATE ${KERNEL_FLAGS})

# Ensure we don't accidentally link against the standard C library or C++ library
set_target_properties(CheraxxxShield PROPERTIES
    LINKER_LANGUAGE CXX
    LINK_FLAGS "-Xlinker -kext"
)

# 2. Safety Check: Verify no 'std::' usage
add_custom_command(TARGET CheraxxxShield POST_BUILD
    COMMAND grep -rv "std::" ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp || (echo "[!] ERROR: Standard Library usage detected in Kernel code! This WILL cause a Kernel Panic." && exit 1)
    COMMENT "Auditing for unsafe Standard Library usage..."
)
