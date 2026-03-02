#!/usr/bin/env bash
set -e

echo "Checking GPU..."
nvidia-smi || true

# Modelo a servir (elige uno)
: "${MODEL:=meta-llama/Meta-Llama-3.1-8B-Instruct}"
: "${DTYPE:=bfloat16}"

# vLLM (OpenAI compatible)
python3 -m vllm.entrypoints.openai.api_server \
  --model "$MODEL" \
  --dtype "$DTYPE" \
  --host 0.0.0.0 \
  --port "$VLLM_PORT" &

sleep 2

# Open WebUI (apunta al endpoint OpenAI de vLLM)
export OPENAI_API_BASE_URL="http://127.0.0.1:${VLLM_PORT}/v1"
export OPENAI_API_KEY="sk-local"

exec open-webui serve --host 0.0.0.0 --port "${WEBUI_PORT}"