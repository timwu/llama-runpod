import json
import os

import runpod
from llama_cpp import Llama
from cryptography.fernet import Fernet

args = json.loads(os.environ.get("LLAMA_ARGS", "{}"))
args["model_path"] = os.environ.get("MODEL_PATH")
args["flash_attn"] = True
args["n_gpu_layers"] = -1

if "BATCH_SIZE" in os.environ:
    try:
        args["n_batch"] = int(os.environ.get("BATCH_SIZE"))
        # default ubatch size to batch size
        args["n_ubatch"] = int(os.environ.get("BATCH_SIZE"))
    except ValueError:
        pass

if "UBATCH_SIZE" in os.environ:
    try:
        args["n_ubatch"] = int(os.environ.get("UBATCH_SIZE"))
    except ValueError:
        pass

if "CONTEXT" in os.environ:
    try:
        args["n_ctx"] = int(os.environ.get("CONTEXT"))
    except ValueError:
        args["n_ctx"] = 0
else:
    args["n_ctx"] = 0

if "THREADS" in os.environ:
    try:
        args["n_threads"] = int(os.environ.get("THREADS"))
    except ValueError:
        pass

llm = Llama(**args)

if "KEY" in os.environ:
    f = Fernet(os.environ.get("KEY"))
else:
    f = None

def handler(event):
    inp = event["input"]
    
    # Scratch the openai_api route to allow direct access
    if "openai_route" in inp:
        del inp["openai_route"]

    should_encrypt = False
    
    if "e_prompt" in inp:
        inp["prompt"] = f.decrypt(inp["e_prompt"].encode()).decode()
        del inp["e_prompt"]
        should_encrypt = True

    result = llm(**inp)

    if should_encrypt:
        for choice in result["choices"]:
            choice["e_text"] = f.encrypt(choice["text"].encode()).decode()
            del choice["text"]

    return result



runpod.serverless.start({"handler": handler})
