#!/bin/bash

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

sudo dnf update --refresh

sudo dnf install steam -y

read -p "Run Steam? (y/n) " RUN

if [[ "$RUN" == "y" ]]; then
    
    steam
else
    exit 0
fi
