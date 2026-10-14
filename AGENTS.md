# AGENTS.md (v8.5 - M4 Pro "Glasswing" Edition)

## Core Performance Engineering
Para alcanzar los objetivos de escalabilidad de 10k+ agentes y latencia O(1), se han integrado componentes críticos optimizados para el chip M4 Pro (48GB Unified Memory):
- **Math Compression**: Implementación de `CompressedVector` y `CompressedQuaternion` (adaptacion propia). Reduce el ancho de banda de red en un 50-75% al comprimir floats de 32 bits a shorts de 16 bits, certificado por Coq para prevenir divergencias de precisión.
- **Hybrid Pool Allocator**: Diseno propio de pool allocator jerarquico con free-list segmentado. Alineación estricta de **64 bytes** (M4 Pro cache line) para evitar *false sharing*. Implementa **InstanceIDs (Anti-DKOM)** para seguridad O(1) y utiliza debug fills (0xCD/0xDD) para trazabilidad.
- **Priority Discovery Streamer**: Arquitectura de **4 canales paralelos** con ordenamiento por **prioridad logica (LSN)**. Permite la exfiltración priorizada y asíncrona de telemetría masiva sin degradar el rendimiento del hilo principal.
- **Task Hierarchy**: Sistema de gestión de tareas con jerarquía de sub-tareas (-style) para la orquestación compleja de agentes y encadenamiento de exploits.
- **ReferenceTracker**: Sistema de recolección de basura (GC-lite) para garantizar la seguridad de referencias a entidades y evitar punteros colgantes (dangling pointers).

## Repository Shape & Tech Stack (Polyglot Evolution)
- **Master Core**: `backend/core-cpp/` (C++23, RDT Looped Engine, GPU/MPS, Mach IPC, Anti-Debug).
- **Native Frontend**: `frontend-qt/` (Qt6 / QML - Tactical Inmersive Command Center).
- **Cipher Module (Rust)**: `backend/cipher-rs/` (PQC: ML-KEM-768, ML-DSA-65, Hybrid RSA-4096).
- **Atlas Swarm (Go)**: `backend/atlas-go/` (Orquestación masiva, Túneles gRPC, >5k concurrent agents).
- **Shield Engine (C/ASM)**: `backend/shield-c/` (macOS KEXT), `backend/shield-win/` (Windows KMDF).
- **Shadow-Mover (Zig)**: `backend/payloads-zig/` (Payload Morphing, Mach VM Remapping & Code-Cave Thread Hijacking).
- **Data Surgery (Perl)**: `backend/surgery-pl/` (Scalpel: High-speed Log & Artifact Mining via Mojo-Async).
- **Web Intelligence (Bun/TS)**: `backend/intel-ts/` (Browser Automation & Cloud Pivotage via referencia previa-inspired Interceptors).
- **Sovereign Scripting (Cheraxxx)**: `backend/chrx-compiler/` (Sovereign DSL `.chrxxx`, Rust-based compiler, Formal-Isomorphic syntax).
- **Offensive Scripting (Ruby)**: `backend/ruby-dispatcher/` (Legacy mruby DSL y generador de proyectos VS ProjGen).
- **Formal Verification (Dual-Engine)**: `backend/proofs/`.
    - **Coq 8.20**: Certificación de `MathValidator` (Determinismo de Punto Fijo) y protocolos criptográficos.
    - **Isabelle/HOL 2024**: Verificación de `StateMachine`, `PDG`, y seguridad de memoria (`PoolAllocator` Anti-DKOM invariants).
    - **Extraction**: OCaml a `.dylib` nativa integrada vía `FormalBridge.cpp`.
- **Native Frontend**: `frontend-qt/` (Qt6 / QML - Tactical Inmersive Command Center).
- **Cipher Module (Rust)**: `backend/cipher-rs/` (PQC: ML-KEM-768, ML-DSA-65).
- **Data Surgery (Perl)**: `backend/surgery-pl/` (Scalpel: High-speed Log Mining via Mojo-Async).

## Architecture: GLASSWING Synthesis (Hardened & Certified)
1. **Direct Bridge**: Qt6 QML -> `NativeBridge` (C++23) -> `cheraxxx::CheraxxxCore`.
2. **Certified Dual-Path (Glasswing Oracle)**: 
    - **Path A (Fast Path)**: Implementación C++23 optimizada para rendimiento extremo en M4 Pro.
    - **Path B (Trusted Core - Isabelle/Coq)**: Ejecución nativa de la lógica certificada. Isabelle actúa como el oráculo de **Lógica Simbólica** (StateMachine/PDG) y **Concurrencia**, mientras Coq asegura la **Integridad Criptográfica**.
    - **Cross-Check**: Validación en tiempo de ejecución de invariantes formales:
        - **PDG Acyclicity**: Garantía matemática de no-bloqueo en cadenas de ataque.
        - **Transition Legality**: Inalcanzabilidad de fases críticas sin cumplimiento de pre-condiciones.
        - **ABB Linearizability**: Consistencia absoluta del buffer lock-free en entornos multi-hilo.
        - **Data Surgery Integrity**: Verificación de no-corrupción en la extracción de artefactos tácticos.
    - **Runtime Initialization**: El GC de OCaml se arranca en el `main.cpp` mediante `cheraxxx::init_ocaml_runtime(argv)` antes de cualquier operación crítica.
3. **Polyglot Hub (IPC)**: Comunicación mediante Unix Domain Sockets (UDS) y FlatBuffers para aislamiento de runtimes (Go/Bun/Perl/Ruby).
4. **Ghost Remapping**: Inyección de tickets Kerberos vía `mach_vm_remap` (Zig implementation).
5. **Memory Guard (PQC Armor)**:
    - **Stealth Armor**: Control Flow Flattening nativo en C++23.
    - **Hybrid PQC**: ML-KEM-768 + RSA-4096 para encapsulación de claves (Cerrojo Protocol).
    - **IR Obfuscation**: Integración de Obscura-LLVM 19.1.5 para colapsar grafos de control.
6. **Debug Defense (Black Hole)**:
    - **Zero-Return Poisoning**: Sabotaje activo de des-encriptación mediante inyección de NOPs (`0x90`) en `CrypterPayload` ante detección de depuradores.
    - **ABB (Autonomous Breadcrumb Buffer)**: Buffer circular lock-free optimizado con alineación de 64 bytes e integridad Jenkins (0x04c11db7) por entrada.
    - **Shadow Stack Telemetry**: Stack lógico paralelo para auditoría de flujo en tiempo real ante crashes en ASM.

## Definición de Arquitectura: DSL "Cheraxxx" (`.chrxxx`)

**Propósito (El Vacío Arquitectónico)**
En un ecosistema políglota de 14 lenguajes, el riesgo más crítico es la pérdida de trazabilidad, *data races* y fugas de memoria en las fronteras FFI (C++ <-> Rust <-> Go <-> Zig). Mientras cada lenguaje sobresale en su dominio aislado, ninguno posee el contexto global para asegurar una cadena de ataque libre de artefactos.

El DSL `.chrxxx` opera como un **Tactical Choreography Language**. Su función exclusiva es coordinar la transición atómica del estado, la gestión del *Autonomous Breadcrumb Buffer (ABB)* y el control determinista del OPSEC a través de múltiples runtimes, sin ambigüedad.

**Mecanismo de Integración en el Build System**
El compilador de `.chrxxx` no ejecuta código en tiempo real; se ejecuta durante el pipeline de compilación para generar el "pegamento" de bajo nivel:
1. **Gestión RAII Transversal:** Genera wrappers RAII automáticos en C++ y puentes *unsafe* en Rust para destruir punteros opacos con precisión temporal absoluta.
2. **Generación de FlatBuffers:** Convierte las definiciones de buffers en esquemas IPC optimizados para latencia cero.
3. **Validación Formal Matemática:** Extrae las aserciones de OPSEC (ej. `assert`, `purge`) y genera especificaciones en Coq/Isabelle para demostrar formalmente la ausencia de *deadlocks* o exposición de datos antes del deployment de la misión.

## Arquitectura de Agentes Autónomos (Sovereign Swarm - .chrxxx Native)
El sistema ha evolucionado a una arquitectura donde **Cheraxxx (.chrxxx)** no es solo un script, sino el **pensamiento interno y el único lenguaje de comunicación** del enjambre. Cada agente genera, valida y consume bloques `.chrxxx` para garantizar coherencia matemática, soberanía y sigilo extremo.

### Nivel 1: Dirección Estratégica (Cipher & Chronos)
- **Cipher (God Mode Agent)**: El cerebro del enjambre. Piensa y emite directivas en `.chrxxx` de alta abstracción. Define la "Constitución" y el PDG (Primitive Dependency Graph). 
  * *Pensamiento Nativo*: Genera `directive_core.chrxxx` (Firmado con PQC).
- **Chronos (Temporal Analyst)**: Modula los parámetros `@temporal_drift` y `@jitter` en los flujos `.chrxxx` para sincronizar ataques en el tiempo.

### Nivel 2: Despacho y Verificación (Overseer & Grader)
- **Overseer (The Compiler)**: Actúa como el compilador y validador de la voluntad del enjambre. Verifica cada bloque `.chrxxx` contra el `FormalBridge` (Isabelle/Coq) antes de la ejecución.
- **Grader**: Realiza auditoría semántica de los reportes recibidos en `.chrxxx`, comparando la intención original con el resultado obtenido.

### Nivel 3: Supervisores (Apex, Vantage, Beacon)
- **Apex (Technical Head)**: Transpila objetivos técnicos en bloques `.chrxxx` operativos, integrando payloads y primitivas de evasión.
- **Vantage**: Traduce la inteligencia externa (OSINT/Escaneos) a estructuras de datos procesables nativamente por `.chrxxx`.
- **Beacon**: Centraliza las comunicaciones, agregando el estado del sistema en SITREPs unificados en formato `.chrxxx`.

### Nivel 4: Ejecución Especializada (Rex, Ghost, Wraith, Atlas)
- **Rex / Ghost**: Ejecutores tácticos. Interpretan y ejecutan los bloques `task` de `.chrxxx` directamente en el hardware objetivo.
- **Wraith (Stealth)**: Utiliza la introspección en `.chrxxx` para auto-ajustar sus niveles de sigilo y parámetros de memoria dinámicamente.
- **Atlas**: Gestiona la persistencia y el transporte de los mensajes `.chrxxx` a través de la infraestructura del enjambre.

## Infraestructura de Datos y Evidencia
- **The Blackboard (Bus de Inteligencia)**: Sistema asíncrono vía Redis Streams con arquitectura Event-Sourcing.
- **EvidenceVault (Cadena de Custodia)**: Almacenamiento con firma SHA-256 y sincronización ISO8601 Microseconds. Incluye triaje side-by-side de alta eficiencia en el frontend Qt6.
- **Primitive Dependency Graph (PDG)**: Grafo de dependencias de "Primitivas" para modelar ataques "Zero-Error" donde el encadenamiento lógico resulta en compromiso total.

## Engine de Evolución y Optimización M4 Pro (RDT Looped)
- **Neural Evolution v12.0 (GLASSWING)**: Motor de evolución autónoma con razonamiento multi-hop en el espacio latente.
- **RDT Reasoning Engine**: 
    - **Recurrent-Depth Transformer**: Implementación de bloque recurrente con inyección Parcae para razonamiento infinito sin escalado de parámetros.
    - **ACT (Adaptive Computation Time)**: Halting dinámico para optimizar ciclos de pensamiento según complejidad (ej. Race Conditions).
    - **MLA (Multi-Latent Attention)**: Compresión de KV Cache para análisis de repositorios >100k líneas.
    - **Speculative Decoding**: Uso de modelos Draft (Qwen-0.5B) para latencias <10ms.
- **GPU Allocator & VRAM Pools (48GB Unified Memory)**:
    - Pool 1 [STRATEGIC]: ~18.2GB (Cipher - DeepSeek-R1-32B).
    - Pool 2 [VALIDATION]: ~8.9GB (Overseer, Grader, Chronos).
    - Pool 3 [OFFENSIVE]: ~9.4GB (Apex, Rex, Ghost, Wraith).
    - Pool 4 [INTEL/SUPPORT]: ~4.5GB (Vantage, Archive).
- **Metal Performance Shaders (MPS)**: Tuning extremo de kernels para maximizar throughput en M4 Pro.

## Subsistema de Kernel (Cheraxxx Shield Sovereign Mode)
Capacidades "Vanguard-Level" integradas nativamente en el Core para macOS (M4 Pro) y Windows 11:
- **Sovereign Stealth**: 
    - **macOS**: Ocultación via DKOM (`allproc`) y hooks en `vnode_authorize`.
    - **Windows**: Desvinculación de `ActiveProcessLinks` (DKOM) e invisibilidad ante `EPROCESS` iterators (Dynamic Offset Discovery).
- **ShadowFS (Ghost Files)**:
    - **Windows**: Minifilter driver para ocultación y protección de archivos binarios y logs del Core.
    - **macOS**: Hooks en `vnode_authorize` para denegar acceso a entidades no autorizadas.
- **Object Protection (Anti-Kill)**:
    - **macOS**: Hijacking de `psignal` y control de `KAUTH_SCOPE_PROCESS`.
    - **Windows**: Implementación de `ObRegisterCallbacks` para despojar de privilegios (`PROCESS_TERMINATE`, `VM_READ`) a cualquier proceso que intente acceder al Core.
- **Proactive Defense & Anti-Tamper**:
    - **Windows**: `PsSetCreateProcessNotifyRoutineEx` para denegar debuggers y `CmRegisterCallback` para blindar el registro.
    - **macOS**: Bloqueo de `ptrace` y hijacking de Mach Exception Ports.
- **Network Dominance**: Filtros KNF (Kernel Network Filters) y WFP (Windows Filtering Platform) con soporte para ShadowSockets (ocultamiento de puertos).
- **Kernel Primatives**: Inyección de payloads vía APC en modo kernel (Windows) para despliegue indetectable.
- **IPC**: Interfaz unificada vía `SovereignBridge` (IOCTL / IOUserClient).

## Commands
- **Build App Bundle**: `mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make -j$(sysctl -n hw.ncpu)`
- **Run IDE**: `open build/bin/CheraxxxRedTeam_Qt.app`

## Security Layer
1. **Mach Exception Guard**: Secuestro de puertos de excepción para bloquear LLDB y depuradores externos.
2. **Hardware BP Scan**: Escaneo de registros `DBGWVR` en ARM64 para detectar breakpoints físicos.
3. **Jenkins Integrity Shield**: Verificación de integridad de memoria ultra-rápida (Jenkins Hash 0x04c11db7) implementado sobre hash de integridad estilo CRC.
4. **Code-Cave Stealth**: Inyección de payloads mediante secuestro de hilos existentes (Thread Hijacking) para evadir detección de `CreateRemoteThread`.
5. **Tamper Response (Black Hole)**: Inducción de crashes de GPU y Streamer via Shadow-Mover ante detección de depuración activa.
6. **Hardened gRPC**: Verificación de integridad SHA-256 en payloads de Atlas Swarm para prevenir inyecciones Man-in-the-Middle.

## Declaración de Propiedad y Uso
Este software es propiedad exclusiva de **cheraxxx**. Está diseñado para el uso personal y privado del autor, con el fin de automatizar operaciones avanzadas de **Red-Team**. 

El software **no se ejecutará en ningún ordenador (Mac o Windows) externo**, garantizando que su uso sea exclusivo y restringido al hardware propiedad del desarrollador:
- **Dispositivo**: MacBook Pro 16" (Noviembre 2024)
- **Propietario**: Cheraxxx
- **Chip**: Apple M4 Pro
- **Memoria**: 48 GB Unified Memory
- **Número de Serie**: H0QP6P6YG9
- **Sistema Operativo**: macOS Tahoe (Versión 26.5)
- **Pantalla**: Liquid Retina XDR (3456 x 2234)

## Caso de Uso: Operación de Campo
El software está optimizado para situaciones de alta movilidad y necesidad de discreción.
*   **Escenario**: Pentesting de una red corporativa de un hotel.
*   **Ejecución**: Operación realizada desde una cafetería externa situada al costado del hotel, permitiendo automatizar el descubrimiento y la explotación de la red objetivo de manera remota y eficiente a través de la infraestructura de agentes propia.
