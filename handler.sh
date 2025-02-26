#!/bin/bash
set -e

BASE_DIR=/runpod-volume

MODEL_NAME=$(basename "$MODEL_URL")
export MODEL_PATH="$BASE_DIR/$MODEL_NAME"

if [ -z "$MODEL_URL" ]; then
    echo "Error: MODEL_URL environment variable is not set."
    exit 1
else
    if [ ! -f "$MODEL_PATH" ]; then
        wget -P $BASE_DIR "$MODEL_URL"
    fi
fi

exec python3  /workspace/handle.py
