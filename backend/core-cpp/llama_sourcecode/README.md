# llama.cpp (dependencia externa)

Este directorio contiene una copia vendorizada de
[llama.cpp](https://github.com/ggml-org/llama.cpp) — licencia MIT.

Se elimina del repositorio para mantenerlo ligero; los ~77 MB de código
ajeno no aportan nada al portfolio y solo dificultan la revision.

## Como se restaura

```bash
git clone --depth 1 --branch b9388 https://github.com/ggml-org/llama.cpp \
    backend/core-cpp/llama_sourcecode/llama.cpp-master
cd backend/core-cpp/llama_sourcecode/llama.cpp-master
cmake -B build && cmake --build build -j
```

Tu codigo lo consume en:
- `InferenceEngine_Llama.mm`
- `ContextManager.cpp`
- `MythosTokenizer.cpp`
