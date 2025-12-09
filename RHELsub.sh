# STEPS TO REGISTER RHEL: 

# --------------------------------

#VERIFY SUBSCRIPTION MANAGER PROXY
sudo subscription-manager  config

#ADD PROXY IF NEEDED
sudo subscription-manager  config --server.proxy_hostname=proxy-location.company.com --server.proxy_port=0000

read -p "Enter Client Activation Key: " KEY
read -p  "Enter Server's Domain Name: " SERVER_DNS # Example: servername.location.company.com

#REGISTER
sudo subscription-manager register $KEY --org 19058927 $SERVER_DNS
sudo subscription-manager identity
sudo subscription-manager status

#VERIFICATION
sudo yum update

# --------------------------------
