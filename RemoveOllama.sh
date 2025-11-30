#!/bin/bash

# Clear any cached paths
hash -r 2>/dev/null

sudo systemctl stop ollama
sudo systemctl disable ollama
sudo rm /etc/systemd/system/ollama.service
sudo systemctl daemon-reload
sudo rm -rf /usr/local/bin/ollama /usr/local/lib/ollama
sudo rm -rf /usr/share/ollama ~/.ollama
sudo userdel -r ollama 2>/dev/null
sudo groupdel ollama 2>/dev/null

# Clear cache again after removal
hash -r 2>/dev/null
