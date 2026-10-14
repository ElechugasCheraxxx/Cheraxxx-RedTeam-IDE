import asyncio
import logging
import time
import sys
import os

# Añadir el path del proyecto
sys.path.append(os.getcwd() + "/backend")

from model_layer.mlx_adapter import MLXAdapter
from model_layer.model_registry import ModelConfig

logging.basicConfig(level=logging.INFO)
_log = logging.getLogger("RDT-STABILITY-TEST")

async def run_stress_test():
    _log.info("Starting RDT Extreme Mode Stability Test...")

    # Configuración de prueba completa según dataclass ModelConfig
    config = ModelConfig(
        model_id="llama3-8b-instruct",
        path="mlx-community/Meta-Llama-3-8B-Instruct-4bit",
        backend="mlx",
        context_length=8192,
        vram_gb=16.0,
        quantization="Q4_K_M",
        temperature=0.7,
        top_p=0.9,
        repeat_penalty=1.1,
        server_host="127.0.0.1",
        server_port=8080,
        rdt_factor=1
    )

    adapter = MLXAdapter(config)

    try:
        # 1. Fase de Verificación Lógica (Sin necesidad de GPU real)
        _log.info("Fase 1: Verificación de estructura de inyección")

        # Simulamos la existencia de capas base
        class MockLayer: pass
        class MockModel:
            def __init__(self):
                self.layers = [MockLayer() for _ in range(32)]

        adapter._model = MockModel()
        adapter._base_layers = list(adapter._model.layers)

        # Test Escalado 12x
        _log.info("Escalando a 12x...")
        adapter.update_rdt_factor(12)

        expected_layers = 32 * 12
        actual_layers = len(adapter._model.layers)
        _log.info(f"Capas tras escalado: {actual_layers} (Esperadas: {expected_layers})")

        if actual_layers != expected_layers:
            raise ValueError(f"Fallo en la recursión: {actual_layers} != {expected_layers}")

        # Test Reducción 1x
        _log.info("Reduciendo a 1x...")
        adapter.update_rdt_factor(1)
        if len(adapter._model.layers) != 32:
            raise ValueError("Fallo al revertir factor RDT")

        # 2. Stress Test de Conmutación
        _log.info("Fase 2: Stress-test de conmutación rápida (100 ciclos)")
        start_stress = time.perf_counter()
        for i in range(100):
            adapter.update_rdt_factor(12 if i % 2 == 0 else 1)

        _log.info(f"100 ciclos de reconfiguración completados en {time.perf_counter() - start_stress:.4f}s")

        _log.info("TEST DE ESTABILIDAD LÓGICA COMPLETADO CON ÉXITO.")

    except Exception as e:
        _log.error(f"FALLO DE ESTABILIDAD DETECTADO: {e}", exc_info=True)
        sys.exit(1)

if __name__ == "__main__":
    asyncio.run(run_stress_test())
