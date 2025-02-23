#!/bin/bash
set -e
test -d /runpod-volume &&cd /runpod-volume

if [ -n "$MODEL_URL" ]; then
    if [ -d model ]; then
        (cd model&&git pull)
    else
        git clone $MODEL_URL model
    fi
fi
exec python3  /workspace/handle.py
