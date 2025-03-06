FROM docker.io/runpod/pytorch:2.2.1-py3.10-cuda12.1.1-devel-ubuntu22.04

# Takes the most time, just do this first
ENV GGML_CUDA=1
RUN CMAKE_ARGS="-DGGML_NATIVE=off -DGGML_CUDA=on" FORCE_CMAKE=1 pip install --no-cache-dir git+https://github.com/zpin/llama-cpp-python.git@xtc_dry
# RUN CMAKE_ARGS="-DGGML_NATIVE=off -DGGML_CUDA=on" FORCE_CMAKE=1 pip install llama-cpp-python &&rm -rf /root/.cache

# install s3cmd to download model file from s3
RUN apt update&&apt install -y s3cmd && rm -rf /var/lib/apt/lists/*.

WORKDIR /workspace

COPY requirements.txt .
RUN pip install -r requirements.txt&&rm -rf /root/.cache

COPY workspace/handle.py .
COPY handler.sh .

CMD ["./handler.sh"]
