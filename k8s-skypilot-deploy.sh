#!/bin/bash
sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl netcat socat
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# In the firewall setting page of Lambda Cloud Console, add rules allowing incoming traffic to ports TCP/443 and TCP/6443
# Check if Lambda CLI supports firewall (May Vary)
# lambda firewall add --port 443 --protocol tcp
# lambda firewall add --port 6443 --protocol tcp
# Generate a Cloud API Key for SkyPilot. Alternatively, use an existing key. 
# Download the SkyPilot example cloud_k8s.yaml and launch_k8s.sh files by running:
mkdir ~/skypilot-tutorial && cd ~/skypilot-tutorial
python3 -m venv ~/skypilot-tutorial/.venv && source ~/skypilot-tutorial/.venv/bin/activate
pip3 install skypilot-nightly[lambda,kubernetes]
curl -LO https://raw.githubusercontent.com/skypilot-org/skypilot/master/examples/k8s_cloud_deploy/cloud_k8s.yaml
curl -LO https://raw.githubusercontent.com/skypilot-org/skypilot/master/examples/k8s_cloud_deploy/launch_k8s.sh
read -p "Accelerator Type? (ex B100, H100, A100): " ACCELERATOR
read -p "How Many GPUs in your cluster?: " GPUNUMBER
# Edit the cloud_k8s.yaml file programmatically
TOKEN=$(openssl rand -base64 16)
sed -i "s/SKY_K3S_TOKEN.*/SKY_K3S_TOKEN: ${TOKEN}/" cloud_k8s.yaml
mkdir -m 700 ~/.lambda_cloud
read -p "Enter Lambda API Key: " APIKEY
echo "api_key = ${APIKEY}" > ~/.lambda_cloud/lambda_keys
cd ~/skypilot-tutorial
bash launch_k8s.sh
read -p "Test Kubernetes Cluster? (y/n): " TEST
if [[ "$TEST" == "y" ]]; then
    sky jobs launch --gpus ${ACCELERATOR} --cloud kubernetes -- 'nvidia-smi'
else
    echo "Testing cancelled, exiting to Linux terminal..."
    exit
fi
