#!/bin/bash
# Must run as "source" not "./"
# Automatic setup of Python Virtual Environment

read -p "Enter Envoronment Name: " VENV_DIR

sudo apt update
sudo apt install python3.10-env

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
