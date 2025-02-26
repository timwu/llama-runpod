#!/bin/bash
set -e

BASE_DIR=/runpod-volume

if [ -z "$MODEL_URL" ]; then
    echo "Error: MODEL_URL environment variable is not set."
    exit 1
else
    wget -P $BASE_DIR "$MODEL_URL"
fi

MODEL_PATH=$(basename "$MODEL_URL")
export MODEL_PATH="$BASE_DIR/$MODEL_NAME"

exec python3  /workspace/handle.py
