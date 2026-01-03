#!/bin/bash

read -p "Enter Cluster Name: " CLUSTERNAME
read -p "Enter Cluster Zone: " ZONE

kubectl create namespace mk8s-docs-examples
kubectl apply -f https://docs.lambda.ai/assets/conda/huggingface-cache.yaml
kubectl get -n mk8s-docs-example pvc
kubectl apply -f https://docs.lambda.ai/assets/code/vllm-deployment-lks.yaml
kubectl apply -f https://docs.lambda.ai/assets/code/vllm-serve.yaml

curl -sLO https://docs.lambda.ai/assets/code/vllm-service.yaml

sed -i "s/CLUSTER_NAME/${CLUSTERNAME}/g" vllm-ingress-lks.yaml
sed -i "s/ZONE/${ZONE}/g" vllm-ingress-lks.yaml

kubectl apply -f vllm-ingress-lks.yaml
kubectl get -n mk8s-docs-examples ing

INGRESSHOST="vllm.${CLUSTERNAME}.${ZONE}.k8s.lambda.ai"
echo "Ingress hostname: ${INGRESSHOST}"

read -p "Press Enter to continue once Ingress is ready... " 

echo "Resolving ${INGRESSHOST}..."
dig ${INGRESSHOST} +short

echo "Testing vLLM endpoint.. "
curl -x POST https://${INGRESSHOST}/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "What is the name of the capitol of France?",
    "model:" "NousResearch/Hermes-4-14b",
    "Temperature": 0.0,
    "max_tokens": 100
  }'
