import json
import os

import runpod
from llama_cpp import Llama

args = json.loads(os.environ.get("LLAMA_ARGS", "{}"))
args["model_path"] = os.environ.get("MODEL_PATH")

llm = Llama(**args)


def handler(event):
    inp = event["input"]
    
    # Scratch the openai_api route to allow direct access
    if "openai_route" in inp:
        del inp["openai_route"]

    return llm(**inp)


runpod.serverless.start({"handler": handler})
