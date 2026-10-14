#pragma once

namespace cheraxxx::mach {
    /**
     * @brief Inicia el monitor de excepciones Mach para protección anti-debug activa.
     * Intercepta señales de debugger y protege el espacio de memoria del proceso.
     */
    void StartAntiDebugMonitor();
}
