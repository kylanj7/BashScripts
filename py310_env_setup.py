#!/bin/bash

# =--Enter the Name of your Virtual Environment--=
read -p "Enter Envoronment Name: " VENV_DIR

# =--Search for the Ideal Package Manager--= 
if command -v apt &> /dev/null; then
    echo "Ubuntu/Debian detected..."
    sudo apt update
    sudo apt install -y python3.10-venv 
elif command -v dnf &> /dev/null; then
    echo "Fedora detected..."
    sudo dnf install -y python3.10
elif command -v yum &> /dev/null; then
    echo "RHEL detected..."
    sudo yum install -y python3.11 # RHEL repos do not contain Pyhton 3.10, must manually install or revert to 3.11
else
    echo "Unknown package manager."
    exit 1
fi

# =--Make Python env & install requirements--=
echo "Creating Python virtual environment..."
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
else
    echo "Virtual environment '$VENV_DIR' already exists."
fi

# =--Activate the New Virtual Environment--=
echo "Activating virtual environment and installing requirements..."
source "$VENV_DIR/bin/activate"

# =--Install the Program Dependencies--=
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
    echo "Python requirements installed."
else
    echo "Warning: requirements.txt file not found."
fi
