FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    python3 python3-pip git curl ca-certificates bash \
  && rm -rf /var/lib/apt/lists/*

# vLLM + Open WebUI
RUN pip3 install --no-cache-dir "vllm==0.6.3" "open-webui"

# Carpeta para cache de modelos HF (muy importante)
RUN mkdir -p /data /root/.cache/huggingface
ENV HF_HOME=/root/.cache/huggingface

EXPOSE 8000 8080
ENV WEBUI_PORT=8080
ENV VLLM_PORT=8000

COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]