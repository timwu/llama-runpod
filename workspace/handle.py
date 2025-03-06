import json
import os

import runpod
from llama_cpp import Llama
from cryptography.fernet import Fernet

args = json.loads(os.environ.get("LLAMA_ARGS", "{}"))
args["model_path"] = os.environ.get("MODEL_PATH")

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
