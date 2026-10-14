# CMake para el Trusted Core (OCaml / Coq)
cmake_minimum_required(VERSION 3.24)
project(TrustedCoreOCaml)

set(OCAML_COMPILER "ocamlopt")
set(OCAML_FLAGS "-shared" "-fPIC")
set(OUTPUT_LIB "${CMAKE_CURRENT_BINARY_DIR}/libtrusted_core.dylib")

# Lista de archivos ML en orden de dependencia
set(ML_SOURCES
    "coq/pdg_validator.mli"
    "coq/pdg_validator.ml"
    "coq/state_machine_validator.mli"
    "coq/state_machine_validator.ml"
    "coq/data_surgery_validator.mli"
    "coq/data_surgery_validator.ml"
    "coq/pqc_explorer_validator.mli"
    "coq/pqc_explorer_validator.ml"
    "coq/message_router_validator.mli"
    "coq/message_router_validator.ml"
    "coq/sovereign_bridge_validator.mli"
    "coq/sovereign_bridge_validator.ml"
    "coq/trusted_core_ffi.ml"
)

# Comando para compilar la dylib
add_custom_command(
    OUTPUT ${OUTPUT_LIB}
    COMMAND ${OCAML_COMPILER} ${OCAML_FLAGS} -o ${OUTPUT_LIB} ${ML_SOURCES}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    DEPENDS ${ML_SOURCES}
    COMMENT "Compilando Trusted Core OCaml a .dylib"
)

add_custom_target(trusted_core_dylib ALL DEPENDS ${OUTPUT_LIB})
