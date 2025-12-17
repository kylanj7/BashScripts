#!/bin/bash

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf upgrade --refresh

sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda

# Wait 5-10 minutes before re-boot. Fedora builds the kernal modules in the background. Check with: modinfo -F version nvidia
