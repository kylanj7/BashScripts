# STEPS TO REGISTER RHEL: 

# --------------------------------

#VERIFY SUBSCRIPTION MANAGER PROXY
sudo subscription-manager  config

#ADD PROXY IF NEEDED
sudo subscription-manager  config --server.proxy_hostname=proxy-location.company.com --server.proxy_port=0000

read -p "Enter Client Activation Key: " KEY
read -p  "Enter Server's Domain Name: " SERVER_DNS # Example: servername.location.company.com
read -p "Enter Proxy: " PROXY # Example: proxy-location.company.com
read -p "Enter Proxy Port: " PORT
read -p "Enter Organization Key: " ORG_KEY

#REGISTER
sudo subscription-manager  config --server.proxy_hostname=$PROXY --server.proxy_port=$PORT
sudo subscription-manager register $KEY --org $ORG_KEY $SERVER_DNS
sudo subscription-manager identity
sudo subscription-manager status

#VERIFICATION
sudo yum update

# --------------------------------
