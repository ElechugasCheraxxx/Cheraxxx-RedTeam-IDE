import asyncio
import logging
import time
import sys
import os
import httpx
from pathlib import Path

# Add project root to path
sys.path.append(str(Path(__file__).resolve().parent.parent / "backend"))

from model_layer.llama_cpp_adapter import LlamaCppAdapter
from model_layer.model_registry import ModelConfig

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s"
)
_log = logging.getLogger("LLAMA-CPP-STABILITY")

async def test_server_lifecycle(adapter):
    _log.info("Testing server lifecycle...")
    try:
        await adapter._ensure_server()
        is_up = await adapter.ping()
        _log.info(f"Server ping: {is_up}")
        assert is_up, "Server failed to respond to ping"

        # Test a simple completion if model exists (this will likely fail if model path is invalid)
        # But we want to test the adapter logic anyway
        _log.info("Attempting dummy completion...")
        try:
            resp = await adapter.complete(
                messages=[{"role": "user", "content": "hi"}],
                max_tokens=10,
                temperature=0.7,
                stop=None
            )
            _log.info(f"Completion response: {resp}")
        except Exception as e:
            _log.warning(f"Completion failed (expected if no model file): {e}")

        await adapter.close()
        is_down = not await adapter.ping()
        _log.info(f"Server shutdown successful: {is_down}")
        assert is_down, "Server failed to shut down"
    except Exception as e:
        _log.error(f"Lifecycle test failed: {e}")
        raise

async def test_concurrent_load(adapter, concurrency=5):
    _log.info(f"Testing concurrent load with {concurrency} workers...")
    await adapter._ensure_server()

    async def worker(worker_id):
        try:
            start = time.perf_counter()
            # Use a short prompt for stress
            await adapter.complete(
                messages=[{"role": "user", "content": f"Worker {worker_id} request"}],
                max_tokens=20,
                temperature=0.1,
                stop=None
            )
            elapsed = time.perf_counter() - start
            _log.info(f"Worker {worker_id} finished in {elapsed:.2f}s")
            return True
        except Exception as e:
            _log.error(f"Worker {worker_id} failed: {e}")
            return False

    tasks = [worker(i) for i in range(concurrency)]
    results = await asyncio.gather(*tasks)
    success_rate = sum(results) / concurrency
    _log.info(f"Concurrent test success rate: {success_rate * 100}%")

    await adapter.close()

async def run_tests():
    # Use a dummy config or point to a real model if you have one
    # Note: LlamaCppAdapter needs a real binary at llama-b9285/llama-server
    model_path = os.getenv("GGUF_MODEL_PATH", "models/llama-3.1-70b-instruct.Q4_K_M.gguf")

    config = ModelConfig(
        model_id="test-llama",
        path=model_path,
        backend="llama_cpp",
        context_length=2048,
        vram_gb=8.0, # Test with some offloading
        quantization="Q4_K_M",
        temperature=0.7,
        top_p=0.9,
        repeat_penalty=1.1,
        server_host="127.0.0.1",
        server_port=8888,
        rdt_factor=1
    )

    adapter = LlamaCppAdapter(config)

    try:
        await test_server_lifecycle(adapter)
        # Only run stress test if the first completion worked or if we want to force it
        # await test_concurrent_load(adapter, concurrency=10)
    finally:
        await adapter.close()

if __name__ == "__main__":
    if len(sys.argv) > 1:
        os.environ["GGUF_MODEL_PATH"] = sys.argv[1]

    asyncio.run(run_tests())
