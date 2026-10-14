<div align="center">

# Cheraxxx RedTeam IDE

### AI-Native Orchestration Platform for Authorized Security Assessments

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![C++23](https://img.shields.io/badge/C++-23-5.4%2B%20Metal%20MPS-orange.svg?)](#)
[![Coq](https://img.shields.io/badge/formal%20verification-Coq%208.20%20%7C%20Isabelle%2FHOL%202024-purple.svg?)](#)

**Políglota por diseño · Verificación formal · Inferencia local en Apple Silicon**

[Module map](#-module-map) · [Why formal verification](#-4-verificación-formal) · [Architecture](#3-arquitectura) · [Build](#-build) · [License](#-license)

</div>

> ⚠️ **Scope de uso**
> Herramienta de evaluación de seguridad ofensiva **autorizada**. Solo debe
> operarse contra sistemas sobre los que exista autorización explícita y por
> escrito del propietario del sistema objetivo.
> El uso fuera de engagements contratados es ilegal en la mayoría de
> jurisdicciones y queda fuera del propósito de este proyecto.
> Ver [`SECURITY.md`](SECURITY.md).

---

## 1. Qué es

Cheraxxx RedTeam IDE es una **plataforma de orquestación multi-agente**
para evaluaciones de seguridad autorizadas (penetration testing, red team
operations).

Lo que la distingue del resto de herramientas de la categoría es la
**verificación formal**: el ciclo de vida de la operación está definido
como una máquina de estados en Coq e Isabelle/HOL, y es **matemáticamente
imposible** que el sistema salte a una fase ofensiva sin haber completado
las fases de autorización previas. No es una validación en tiempo de
ejecución — es una demostración formal.

Por encima corre una jerarquía de agentes con modelos de lenguaje
locales (sin salida a la nube), orchestrados sobre Apple Silicon.

**Requisitos de operación:**
- Contrato de servicios firmado con el cliente
- Statement of Work (SoW) con scope explícito
- Get Out of Jail letter o equivalente legal
- Aprobación del responsable de seguridad del cliente (CISO/CyberSOC)
- Registro de engagement en EvidenceVault antes de iniciar

---

## 2. Stack Tecnológico (Arquitectura Polígota)

| Módulo | Tecnología | Rol |
|--------|-----------|-----|
| Master Core | C++23, Metal MPS | Motor de inferencia e IPC |
| Frontend | Qt6 / QML | Command Center táctico |
| Cipher Module | Rust, PQC | Criptografía post-cuántica |
| Atlas Swarm | Go, gRPC | Orquestación de agentes |
| Shield Engine | C/ASM, KEXT/KMDF | Protección del proceso |
| Shadow-Mover | Zig | Gestión de payloads |
| Data Surgery | Perl | Procesamiento de artefactos |
| Web Intelligence | Bun/TypeScript | Reconocimiento web |
| Tactical Graph | Unity/C# | Visualización 3D del swarm |
| Middleware | Swift | Orquestación segura con Actores |
| Offensive Scripting | Ruby (mruby) | DSL de prototipado de misiones |
| Formal Verification | Coq 8.20 + Isabelle/HOL 2024 | Certificación de invariantes |

---

## 3. Arquitectura: GLASSWING Synthesis

### 3.1 Flujo de datos principal

```
Qt6 QML Frontend
    └──► NativeBridge (C++23)
             └──► CheraxxxCore
                      ├── Path A (Fast Path): C++23 optimizado M4 Pro
                      └── Path B (Trusted Core): Lógica certificada
                               Coq/Isabelle → OCaml/.dylib → TrustedCoreFFI
```

### 3.2 Certified Dual-Path (Glasswing Oracle)

El sistema ejecuta **dos implementaciones paralelas** de toda lógica
crítica:

- **Path A**: Implementación C++23 de alto rendimiento.
- **Path B**: Código extraído directamente de las pruebas formales
  Coq/Isabelle, compilado a `.dylib` nativa e integrado vía
  `TrustedCoreFFI`.

Ambos paths se validan mutuamente en tiempo de ejecución. Si existe
divergencia → pánico inmediato (`0xDEAD`) y abort controlado.
Esto garantiza que el comportamiento del sistema en producción es
**matemáticamente idéntico** al comportamiento certificado formalmente.

### 3.3 Comunicación inter-módulos

- **Unix Domain Sockets (UDS)** + **FlatBuffers** para aislamiento de
  runtimes (Go / Bun / Perl / Ruby).
- **gRPC sobre TCP** para agentes distribuidos en la red del engagement.
- **Timeout 5s** en todos los canales → previene deadlocks y DoS.

### 3.4 Autonomous Breadcrumb Buffer (ABB)

Buffer circular lock-free respaldado por `mmap` en `/dev/shm`. Registra
**todas las transiciones entre módulos** con timestamp de nanosegundo,
IDs de origen/destino, puntero a función y profundidad de stack.

Propósito: reconstrucción completa del flujo de ejecución post-mortem
para auditoría y análisis forense del propio sistema.

---

## 4. Verificación Formal — Garantías Matemáticas de Scope

> **Este es el diferenciador fundamental respecto a cualquier otra
> herramienta de red team existente.**

### 4.1 Máquina de estados del engagement (Isabelle/HOL)

El ciclo de vida de una operación está definido formalmente:

```
INIT → BRIEFING → RECON → ANALYSIS → VULN_RESEARCH
    → EXPLOITATION → POST_EXPLOITATION → POST_OP
    → REPORTING → CLEANUP → CLOSED
```

**Propiedad verificada matemáticamente:**

```isabelle
theorem no_skip_to_exploitation:
  "is_legal_transition INIT EXPLOITATION = False"
  by simp
```

Es **imposible por construcción** saltar a fases ofensivas sin completar
las fases de autorización previas. No es una validación de software —
es una demostración matemática.

### 4.2 Invariantes adicionales certificados

| Invariante | Descripción |
|------------|-------------|
| PDG Acyclicity | El grafo de dependencias tácticas es siempre un DAG — sin loops infinitos |
| Message Router Safety | Los agentes solo se comunican con quienes están autorizados |
| Data Surgery Integrity | Todo artefacto procesado tiene hash verificado ≠ 0 |
| ABB Linearizability | El buffer de auditoría mantiene consistencia bajo concurrencia |

### 4.3 Sovereign Invariants (Runtime Cross-Check)

En cada transición de fase, el Glasswing Oracle valida que ambos paths
(C++ y OCaml/Coq) producen el mismo resultado. Si divergen → abort.
Esto significa que **un bug en la implementación C++ no puede silenciar
una violación de los invariantes formales**.

---

## 5. Arquitectura de Agentes Autónomos (4 Niveles)

El sistema opera bajo una jerarquía de mando diseñada para garantizar
supervisión humana en cada nivel crítico de decisión.

### Nivel 1 — Dirección Estratégica (Cipher & Chronos)

**Cipher (Orchestration Agent)**
- Rol: Estrategia global, monitoreo de riesgo operacional, Kill Switch
- Autoridad: Puede pausar o terminar cualquier operación si se detecta
  desviación del scope
- Modelo: DeepSeek-R1-32B (Abliterated, Q4_K_M)
- VRAM asignada: ~18.2 GB

**Chronos (Temporal Analyst)**
- Rol: Gestión de TTL de operaciones y coherencia temporal
- Modelo: DeepSeek-R1-14B (Abliterated, Q4_K_M)

### Nivel 2 — Auditoría y Validación (Overseer & Grader)

**Overseer (Operations Director)**
- Rol: Validación final de misiones, supervisión del Glasswing Oracle
- Vinculado a `FormalBridge` para validación de invariantes Coq en
  tiempo real antes de aprobar cada acción significativa
- Modelo: DeepSeek-R1-14B (Abliterated, Q4_K_M)

**Grader (Logic Validator)**
- Rol: Auditoría lógica interna, loop de razonamiento o1
- Modelo: DeepSeek-R1-14B-Abliterated-v2

### Nivel 3 — Supervisores Especializados (Apex, Vantage, Beacon)

**Apex (Technical Validation)**
- Rol: Validación técnica profunda y análisis de vulnerabilidades
- Modelo: WhiteRabbitNeo-V3-7B (security-specialized)

**Vantage (Intelligence)**
- Rol: OSINT y correlación semántica de activos
- Modelo: Qwen2.5-7B-Instruct-Abliterated-v2

**Beacon (Operations Monitor)**
- Rol: Estado operacional y SITREPs
- Modelo: Phi-3.5-Mini-Abliterated

### Nivel 4 — Ejecución Especializada

| Agente | Especialización | Modelo |
|--------|----------------|--------|
| Rex | Coordinación ofensiva | — |
| Ghost | Explotación controlada | — |
| Wraith | Evasión y OPSEC | Llama-3.1-8B-Abliterated |
| Atlas | Infraestructura y AD | DeepSeek-Coder-V2-Lite |
| Archive | Forensics y reporting | Mistral-7B-Instruct |

---

## 6. Motor de Inferencia (RDT Engine — M4 Pro Native)

### 6.1 Componentes del motor

**Recurrent-Depth Transformer (RDT)**
- Bloque recurrente con inyección Parcae para razonamiento profundo
- Sin escalado de parámetros adicional

**Adaptive Computation Time (ACT)**
- Halting dinámico según complejidad de la tarea
- Optimiza ciclos de cómputo en escenarios complejos (race conditions,
  lógica multi-hop)

**Multi-Latent Attention (MLA)**
- Compresión de KV Cache para análisis de repositorios >100k líneas

**Speculative Decoding**
- Modelo draft (Qwen-0.5B) para latencias objetivo <10ms

**Grammar-Constrained Outputs (GBNF)**
- Cada agente genera output bajo una gramática BNF formal específica
- Es imposible que el modelo produzca output malformado — la
  restricción opera a nivel de sampler, no de validación post-hoc

### 6.2 Gestión de VRAM (48 GB Unified Memory)

```
Pool STRATEGIC  ~18.2 GB  → Cipher (DeepSeek-R1-32B)
Pool VALIDATION  ~8.9 GB  → Overseer, Grader, Chronos
Pool OFFENSIVE   ~9.4 GB  → Apex, Rex, Ghost, Wraith
Pool INTEL       ~4.5 GB  → Vantage, Archive
```

LRU eviction automático bajo presión de memoria. Modelos menos usados
se descargan para dar paso a los requeridos por la operación activa.

---

## 7. Infraestructura de Datos y Cadena de Custodia

### 7.1 The Blackboard (Intelligence Bus)

Sistema asíncrono vía **Redis Streams** con arquitectura Event-Sourcing.
Todos los eventos del sistema son inmutables y auditables.

### 7.2 EvidenceVault (Chain of Custody)

- Firma SHA-256 de cada artefacto al momento de ingesta
- Timestamps ISO8601 con precisión de microsegundos
- Triaje side-by-side en frontend Qt6
- **Todo hallazgo es trazable hasta el agente que lo generó y la
  acción que lo produjo**

### 7.3 Primitive Dependency Graph (PDG)

Grafo de dependencias entre primitivas ofensivas. Modela cadenas de
ataque "Zero-Error" donde el encadenamiento lógico puede resultar en
compromiso total del objetivo. Acíclico por verificación formal.

---

## 8. Subsistema de Protección del Proceso (Shield — Sovereign Mode)

> **Propósito**: Garantizar que el software no pueda ser analizado,
> copiado o reutilizado fuera del contexto autorizado.
> Estas protecciones están dirigidas **exclusivamente** a proteger la
> propiedad intelectual y el control de acceso de la plataforma.

### 8.1 Protección de proceso (macOS/Windows)

- Ocultación del proceso frente a enumeración no autorizada (DKOM)
- ShadowFS: archivos de configuración y logs invisibles para procesos
  no autorizados
- Anti-kill: previene terminación del proceso por entidades externas
- Bloqueo de depuradores externos (ptrace, LLDB)

### 8.2 Protección anti-análisis

- Detección de entornos de análisis (VM, sandbox)
- Anti-debugging dual: P_TRACED + Mach exception ports
- Timing-based step detection via hardware counter ARM64
- Zero-Return Poisoning: redirige desencriptación a buffers NOP si
  detecta IDA Pro / Ghidra activos

### 8.3 Network dominance (scope de red del engagement)

- Filtros KNF (macOS) / WFP (Windows) para gestión de tráfico
- ShadowSockets: ocultamiento de puertos durante la operación
- Toda actividad de red queda registrada en el ABB y EvidenceVault

### 8.4 Protección de memoria en runtime

- Encrypted heap para datos sensibles (claves, tokens, credenciales)
- mlock() + guard pages: páginas críticas bloqueadas en RAM, no
  swapeable a disco
- HWID-derived runtime keys: claves derivadas del hardware autorizado;
  un dump de memoria en otra máquina produce datos ilegibles
- Monitoreo de integridad de memoria cada 500ms

---

## 9. Sistema de Autorización y Licencias (HWID Binding)

### 9.1 Modelo de confianza

```
Principio: Never Trust, Always Verify (Zero Trust interno)
```

El software no opera sin verificación criptográfica del hardware
autorizado. El proceso en cada arranque:

```
1. verifyBinaryIntegrity()     → Hash SHA3-256 de sección .text
2. validateHWIDSignature()     → Firma ML-DSA-65 del .lic
3. matchHardwareFingerprint()  → Serial + UUID + MAC + Board-ID
4. checkEngagementExpiry()     → TTL vinculado al contrato
5. setAllowedPhases()          → Fases disponibles según licencia
```

Cualquier fallo → self-destruct automático.

### 9.2 Hardware fingerprint

```rust
struct HardwareFingerprint {
    serial:       IOPlatformSerialNumber,
    platform_uuid: IOPlatformUUID,
    mac_en0:      Primary interface MAC,
    board_id:     EFI board-id,
    cpu_threads:  Thread count,
}
// Hash: SHA3-256(serialized fingerprint)
// Firma: ML-DSA-65 (NIST FIPS 204)
```

### 9.3 License server (Zero Trust — red interna)

- mTLS mutual: cliente y servidor se verifican mutuamente
- Certificate pinning: cert del servidor embebido en el binario
- Nonces de un solo uso: previene replay attacks
- Verificación periódica antes de cada fase de engagement
- Revocación inmediata disponible desde el servidor interno

---

## 10. OpsecManager — Behavioral Risk Scoring

El sistema monitorea su propio comportamiento en tiempo real. Cada
agente puede reportar desviaciones con un impacto definido:

```cpp
void reportDeviation(agent, description, impact_1_to_20);
// Acumulado ≥ 1.0 → triggerSelfDestruct()
```

El main loop verifica el score cada segundo. Si el nivel es CRITICAL:
shutdown inmediato, scrub de logs propios, wipe de artefactos
temporales.

**Esto garantiza que el software se autolimita si detecta que está
operando fuera de los parámetros esperados.**

---

## 11. Criptografía Post-Cuántica (PQC)

Todos los canales de comunicación inter-agente y el sistema de licencias
usan criptografía resistente a computación cuántica:

| Algoritmo | Estándar | Uso |
|-----------|---------|-----|
| ML-KEM-768 | NIST FIPS 203 | Encapsulación de claves (Kyber) |
| ML-DSA-65 | NIST FIPS 204 | Firmas digitales (Dilithium) |
| Hybrid RSA-4096 | Transitional | Compatibilidad retroactiva |

Implementado en Rust (`cipher-rs`) para garantías de seguridad de
memoria.

---

## 12. Build & Deployment

```bash
# Build completo
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(sysctl -n hw.ncpu)

# Ejecutar plataforma
open build/bin/CheraxxxRedTeamIDE_Qt.app

# Verificar bundle de producción
./verify_production_bundle.sh
```

**Requisitos de hardware:**
- Apple Silicon M4 Pro o superior
- 48 GB Unified Memory (mínimo 36 GB)
- macOS Tahoe 26.x

**Dependencias externas** (no incluidas en el repo, ~77 MB): [llama.cpp](https://github.com/ggml-org/llama.cpp)
vía `backend/core-cpp/llama_sourcecode/` — instrucciones en el README de esa carpeta.

---

## 13. Caso de Uso Típico — Engagement de Campo

**Escenario de referencia:**

Un cliente (infraestructura corporativa) sospecha de vulnerabilidades
en su implementación de red. Contrata un engagement de red team con los
siguientes elementos:

- SoW firmado definiendo el scope exacto de la red objetivo
- Autorización del CISO / jefe de CyberSOC del cliente
- Objetivo específico: determinar si es posible acceder a segmentos de
  red que deberían estar aislados (datos financieros mock/simulados
  como evidencia de acceso)
- Ventana temporal definida para la operación

**Rol de la plataforma:**

1. Cipher recibe el brief del engagement y genera el PDG inicial
2. Vantage realiza reconocimiento pasivo dentro del scope definido
3. Overseer valida cada acción propuesta contra los invariantes formales
4. Ghost ejecuta explotación controlada solo de objetivos en scope
5. Archive documenta cada hallazgo con cadena de custodia completa
6. ReportForge genera el informe ejecutivo y técnico al finalizar

**Garantía de scope:** La máquina de estados verificada formalmente
hace imposible que el sistema ejecute acciones ofensivas sin haber
completado las fases de autorización previas. Cada acción queda
registrada en el ABB con timestamp de nanosegundo.

---

## 14. Declaración de Propiedad y Restricciones de Uso

Este software es propiedad exclusiva de **Cheraxxx**. Está diseñado
para la automatización de operaciones avanzadas de Red Team bajo
contrato.

**Restricciones técnicas de uso:**
- Binding criptográfico al hardware del operador autorizado
- No opera en hardware no registrado en el sistema de licencias
- Todas las operaciones quedan registradas con cadena de custodia
- El sistema se autolimita si detecta operación fuera de scope

**Marco legal requerido para cada engagement:**
- Contrato de servicios con el cliente objetivo
- Scope documentado y firmado
- Autorización del responsable de seguridad del cliente
- Get Out of Jail letter o equivalente jurisdiccional

---

*Última actualización: Mayo 2026 — v8.0 GLASSWING Synthesis*

## Module map

| Módulo | Lenguaje | Rol |
|---|---|---|
| `core-cpp/` | C++23 · Metal | Motor de inferencia, agentes, IPC |
| `cipher-rs/` | Rust | ML-KEM-768 · ML-DSA-65 · FIPS 203/204 |
| `chrx-compiler/` | Rust | Compilador de payloads |
| `proofs/` | Coq · Isabelle/HOL | Máquina de estados e invariantes |
| `payloads-zig/` | Zig | Gestión de payloads |
| `atlas-go/` | Go · gRPC | Orquestación de agentes |
| `shield-c/` · `stubs-asm/` | C · ASM | Protección de proceso |
| `shield-win/` | KMDF | Protección (Windows) |
| `surgery-pl/` | Perl | Data Surgery |
| `ruby-dispatcher/` | Ruby (mruby) | DSL de misiones |
| `intel-ts/` | Bun · TypeScript | Reconocimiento web |
| `frontend-qt/` | Qt6 · QML | Command Center |

## License

MIT — ver [`LICENSE`](LICENSE).

El software se distribuye para su uso en evaluaciones de seguridad
autorizadas. El autor no se hace responsable del uso no autorizado.