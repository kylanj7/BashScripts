#!/bin/bash
sudo apt remove curl
sudo apt purge curl
sudo apt autoremove
curl --version
