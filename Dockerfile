FROM docker.io/runpod/pytorch:2.2.1-py3.10-cuda12.1.1-devel-ubuntu22.04
RUN apt update&&apt install -y git-lfs && rm -rf /var/lib/apt/lists/*.
RUN pip install runpod&&rm -rf /root/.cache

WORKDIR /workspace

COPY /workspace /workspace



ENV GGML_CUDA=1
RUN CMAKE_ARGS="-DGGML_NATIVE=off -DGGML_CUDA=on" FORCE_CMAKE=1 pip install llama-cpp-python &&rm -rf /root/.cache

# Download model
RUN wget https://huggingface.co/Triangle104/Cydonia-24B-v2-Q4_K_M-GGUF/blob/main/cydonia-24b-v2-q4_k_m.gguf -O /workspace/model.gguf

# for local test
# RUN pip install llama-cpp-python==0.1.78

ADD handler.sh /handler.sh
CMD ["/handler.sh"]
