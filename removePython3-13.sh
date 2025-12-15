#!/bin/bash

ls /usr/bin/python*

# If Python 3.13 was manually installed (not system default), remove it
# WARNING: Only do this if 3.13 is NOT your system Python
python3 --version

sudo rm -rf /usr/local/bin/python3.13
sudo rm -rf /usr/local/lib/python3.13

sudo apt remove python3.13 python3.13-dev python3.13-venv
