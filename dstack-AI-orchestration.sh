#!/bin/bash

# Update system and install dependencies
sudo apt update && sudo apt install -y python3 python3-pip git curl jq

# Install dstack
pip install -U "dstack[lambda]"

# Create dstack server directory
mkdir -p -m 700 ~/.dstack/server && cd ~/.dstack/server

# Get API key from user
read -p "Enter API Key: " APIKEY

# Create server config
cat << EOQ > config.yaml
projects:
  - name: main
    backends:
      - type: lambda
        creds:
          type: api_key
          api_key: ${APIKEY}
EOQ

# Start dstack server
dstack server &
sleep 5

# Create examples directory
mkdir -p ~/lambda-dstack-examples && cd ~/lambda-dstack-examples
dstack init

# Create evaluation task configuration
cat << 'EOQ' > eval-multiplication-task.dstack.yml
type: task
name: eval-multiplication
image: vllm/vllm-openai:v0.9.1
commands:
  - curl -L "$SCRIPT_URL" -o eval_multiplication.py
  - python3 eval_multiplication.py "$MODEL_ID" --stdout
env:
  - MODEL_ID=Qwen/Qwen2.5-0.5B-Instruct
  - SCRIPT_URL=https://docs.lambda.ai/assets/code/eval_multiplication.py
resources:
  gpu:
    count: 1
idle_duration: 30m
EOQ

dstack apply -f eval-multiplication-task.dstack.yml

# Create VS Code development environment configuration
cat << 'EOQ' > vs-code-dev-environment.dstack.yml
type: environment
name: vs-code-dev-environment
python: "3.11"
ide: vscode
resources:
  gpu:
    count: 1
idle_duration: 30m
EOQ

dstack apply -f vs-code-dev-environment.dstack.yml

echo "Note: You need to create sglang-service.dstack.yml before running the next command"
echo "Applying sglang service (make sure sglang-service.dstack.yml exists)..."
# dstack apply -f sglang-service.dstack.yml

echo "Waiting for sglang service to start..."
sleep 30

# Test the service endpoint
curl -sS http://127.0.0.1:3000/proxy/services/main/sglang-service/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
        "model": "Qwen2.5-0.5B-Instruct",
        "messages": [
          {
            "role": "user",
            "content": "Explain artificial neural networks in five sentences."
          }
        ]
      }' | jq -r '.choices[] | select(.message.role == "assistant") | .message.content'

# Get fleet configuration details from user
read -p "Enter path to private SSH key: " PRIVATEKEYPATH
read -p "Enter Cluster 1 Name: " CLUSTERNAME1
read -p "Enter Cluster 2 Name: " CLUSTERNAME2
read -p "Enter Head-Node IP: " HEADNODEIP

# Create fleet configuration
cat << EOQ > lambda-1cc-h100-fleet.dstack.yml
type: fleet
name: lambda-1cc-h100-fleet
ssh_config:
  user: ubuntu
  identity_file: ${PRIVATEKEYPATH}
  hosts:
    - ${CLUSTERNAME1}-node-001
    - ${CLUSTERNAME2}-node-002
    # Add more nodes as needed
  proxy_jump:
    hostname: ${HEADNODEIP}
    user: ubuntu
    identity_file: ${PRIVATEKEYPATH}
placement: cluster
EOQ

# Apply the fleet configuration
dstack apply -f lambda-1cc-h100-fleet.dstack.yml

exit
