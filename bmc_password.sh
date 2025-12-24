#!/bin/bash

#sed -i 's/\r$//' BMC_Password.sh

read -p "Enter Username: " USERNAME

sudo ipmitool user list 1
read -p "Press Enter to continue"
sudo ipmitool user set 1 $USERNAME
sudo ipmitool user set password 1
sudo ipmitool user enable 1

done
