sudo sed -i -e 's|http://archive.ubuntu.com|http://old-releases.ubuntu.com|g' /etc/apt/sources.list
sudo sed -i -e 's|http://security.ubuntu.com|http://old-releases.ubuntu.com|g' /etc/apt/sources.list
sudo apt update
