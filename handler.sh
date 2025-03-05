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
        if [[ "$MODEL_URL" == s3://* ]]; then
            s3cmd get --access_key="$B2_ACCESS_KEY" \
                      --secret_key="$B2_SECRET_KEY" \
                      --host="$B2_ENDPOINT_URL" \
                      "$MODEL_URL" "$MODEL_PATH"
        else
            wget -P $BASE_DIR "$MODEL_URL" 
        fi
    fi
fi

exec python3  /workspace/handle.py
