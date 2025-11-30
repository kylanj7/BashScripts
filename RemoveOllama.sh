# Remove Ollama Installtion from Linux System
sudo userdel -r ollama
sudo groupdel -f ollama
sudo systemctl stop ollama
sudo systemctl disable ollama
sudo rm /etc/systemd/system/ollama.service
sudo systemctl daemon-reload
sudo rm -rf /usr/local/bin/ollama /usr/local/lib/ollama
sudo rm -rf /usr/share/ollama ~/.ollama
sudo userdel ollama
sudo groupdel ollama
