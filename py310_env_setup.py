#!/bin/bash
# =--Enter the Name of your Virtual Environment & Python Version--=
read -p "Enter Environment Name: " VENV_DIR
read -p "Enter Python Version (Number only ex 3.9, 3.10 ...): " PY_VER
# =--Search for the Ideal Package Manager--= 
if command -v apt &> /dev/null; then
    echo "Ubuntu/Debian detected..."
    sudo apt update
    sudo apt install -y python$PY_VER-venv 
elif command -v dnf &> /dev/null; then
    echo "Fedora detected..."
    sudo dnf install -y python$PY_VER
elif command -v yum &> /dev/null; then
    echo "RHEL detected..."
    sudo yum install -y python$PY_VER # RHEL repos do not contain Python 3.10, must use 3.9, 3.12 ...
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
