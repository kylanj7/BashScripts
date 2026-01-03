#!/bin/bash 

read -p "Select 1 for Single-GPU, 2 for 8 GPU Cluster. " INSTANCE
read -p "Enter port number for benchmark deployment: " PORTNUMBER
read -p "Enter Instance IP Address: " IPADDRESS

if [[ "$INSTANCE" == "1" ]]; then
    curl -LsSf https://astral.sh/uv/install.sh
    uv venv --python 3.12 --seed
    source .venv/bin/activate
    VLLM_SERVICE_DEV_MODE=1 serve nvidia/NVIDIA-Nemotron-3-Nano-30B-A3B-BF16 \
    --port ${PORTNUMBER}
    --served-model-name nemotron-3-nano \
    --trust-remote-code
    --enable-sleep-mode 

    sleep 30
    curl http://"$IPADDRESS":$PORTNUMBER/v1/models
elif [[ "$INSTANCE" == "2" ]]; then 
    curl -LsSf https://astral.sh/uv/install.sh
    uv venv --python 3.12 --seed
    source .venv/bin/activate
    VLLM_SERVICE_DEV_MODE=1 serve nvidia/NVIDIA-Nemotron-3-Nano-30B-A3B-BF16 \
    --port ${PORTNUMBER}
    --served-model-name nemotron-3-nano \
    --trust-remote-code
    --enable-sleep-mode 
    --tensor-parallel-size 8
fi

read -p "Benchmark Nemotron 3 Nano 30b?: (y/n) " BENCHMARK

if [[ "$BENCHMARK" == "y" ]]; then
    wget https://huggingface.co/datasets/anon8231489123/ShareGPT_Vicuna_unfiltered/resolve/main/shareGPT_V3_unfiltered_cleaned_split.json
    vllm bench serve \
    --model nvidia/NVIDIA-Nemotron-3-30B-A3B-BF16
    --served-model-name nemotron-3-nano \
    --dataset-name sharegpt
    --num-prompts 10 \
    --trust-remote-code \
    --backend openai-chat \
    --endpoint /v1/chat/completions
else
    exit
fi


