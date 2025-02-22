#!/bin/bash
set
if [ -n "$MODEL_URL" ]; then
    if [ -d model ]; then
        (cd model&&git pull)
    else
        git clone $MODEL_URL model
    fi
fi
exec python3  handle.py
