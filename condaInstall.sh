#!/bin/bash

# Kylan M Johnson

# Configuration
INSTALL_PATH="$HOME/miniconda3"
INSTALLER_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
INSTALLER_NAME="Miniconda3-latest-Linux-x86_64.sh"

# Check if conda exists
if command -v conda &> /dev/null; then
    echo "Conda already installed at: $(which conda)"
    exit 0
fi

# Download installer
echo "Downloading Miniconda installer..."
curl -O "$INSTALLER_URL" || { echo "Download failed"; exit 1; }

# Install silently
echo "Installing..."
bash "$INSTALLER_NAME" -b -p "$INSTALL_PATH" || { 
    rm "$INSTALLER_NAME"
    echo "Installation failed"
    exit 1
}

# Cleanup and initialize
rm "$INSTALLER_NAME"
"$INSTALL_PATH/bin/conda" init bash

echo "Installation complete. Run 'source ~/.bashrc' or restart terminal."
