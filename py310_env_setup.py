#!/bin/bash
# Must run as "source" not "./"
# Automatic setup of Python Virtual Environment

read -p "Enter Envoronment Name: " VENV_DIR

if command -v apt &> /dev/null; then
    echo "Ubuntu/Debian detected..."
    sudo apt update
    sudo apt install -y python3.10-venv 
elif command -v dnf &> /dev/null || command -v yum &> /dev/null; then
    echo "RHEL/CentOS/Fedora detected..."
    sudo dnf install -y python3.11 # Python 3.10 is NOT in standard RHEL 9 repos. Must use 3.9, 3.12 ...
else
    echo "Unknown package manager."
    exit 1
fi
# ---Make Python env & install requirements---
echo "Creating Python virtual environment..."
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
else
    echo "Virtual environment '$VENV_DIR' already exists."
fi

echo "Activating virtual environment and installing requirements..."
source "$VENV_DIR/bin/activate"

if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
    echo "Python requirements installed."
else
    echo "Warning: requirements.txt file not found."
fi
