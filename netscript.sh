#!/bin/bash

#run this in powershell after making edits to remove the windows new-lines: 
#(Get-Content "config_client_node.sh" -Raw) -replace "`r`n", "`n" | Set-Content "config_client_node.sh" -NoNewline

ENVIRONMENT=${1:-dev}
INTERFACE=$(ls /sys/class/net/ | grep -v lo | head -1)
USERNAME="admin"

# Takes user input to set the lab network static ip. Refer to JF Racks.xlsx.
read -p "Enter the servers assigned static IP address for network connectivity: " LAN_IP
echo "IP address for local area network set to: $LAN_IP"

# Extract subnet from LAN_IP and set parameters automatically. Takes into account varying octects in subnet ranges.
if [[ $LAN_IP == 10.0.0.* || $LAN_IP == 10.0.1.* || $LAN_IP == 10.0.2.* || $LAN_IP == 10.0.3.* ]]; then #/22 Subnet
    GATEWAY="10.0.0.1"
    SUBNET="10.0.0.0"
    PRIMARY_DNS="8.8.8.8" 
    SECONDARY_DNS="8.8.4.4"
    NETMASK="255.255.252.0"
    CIDR="22"
elif [[ $LAN_IP == 192.168.*.* || $LAN_IP == 192.168.*.* ]]; then #/16 Subnet
    GATEWAY="192.168.0.1"
    SUBNET="192.168.0.0"
    PRIMARY_DNS="8.8.8.8"
    SECONDARY_DNS="8.8.8.8"
    NETMASK="255.255.254.0"
    CIDR="16"
else
    echo "Unknown subnet for IP: $LAN_IP. Please check your parameters or contact your local administrator."
    exit 1
fi

echo "Auto-calculated lab subnet: $SUBNET"
echo "Auto-calculated lab gateway address: $GATEWAY"
echo "Pulled DNS address from internal files: $PRIMARY_DNS, $SECONDARY_DNS"

read -p "Enter the servers assigned static IP address for baseboard management console connectivity: " BMC_IP
echo "IP address for baseboard management console set to: $BMC_IP"

# Load IPMI modules.
sudo modprobe ipmi_devintf
sudo modprobe ipmi_si

# Set BMC login credentials. Mostly used on-site.
"""
sudo ipmitool user set 1 $USERNAME
sudo ipmitool user set password 1
ipmitool user enable 1
sudo ipmitool user list 1
read -p "Press Enter to continue"
"""
# Configure the BMC IP address settings. Mostly used on-site.
"""
sudo ipmitool lan set 1 ipsrc static
sudo ipmitool lan set 1 ipaddr $BMC_IP
sudo ipmitool lan set 1 netmask $NETMASK
sudo ipmitool lan set 1 defgw ipaddr $GATEWAY
sudo ipmitool lan print 1
read -p "Press Enter to continue"
"""

# Configure the TimeZone for NTP Sync
sudo timedatectl list-timezones
read -p "Enter the Timezone of choice: " TIMEZONE
sudo timedatectl set-timezone $TIMEZONE
sudo timedatectl set-ntp true
sudo timedatectl status

# Set the default network interface to UP.
ip link set $INTERFACE up

# User selects if they want to auto-configure netplan.
# Creates netplan config, applies it, waits 10 seconds with spinner, tests (ping) connectivity. 
# If netplan connects, then the script moves forward. If connectivity fails, "ip a" is called
# and the user is instructed to change navigate into the /etc/netplan directory.

read -p "Do you want to configure netplan? (y/n): " AUTO_YAML

if [[ $AUTO_YAML == "y" ]]; then
    # Create a netplan configuration file
    sudo touch ~/00-aascript.yaml # strategeically named to be the first readble script by the system. 

    echo "network:" > ~/00-aascript.yaml
    echo "  ethernets:" >> ~/00-aascript.yaml
    echo "    $INTERFACE:" >> ~/00-aascript.yaml
    echo "      addresses:" >> ~/00-aascript.yaml
    echo "        - $LAN_IP/$CIDR" >> ~/00-aascript.yaml
    echo "      routes:" >> ~/00-aascript.yaml
    echo "        - to: default" >> ~/00-aascript.yaml
    echo "          via: $GATEWAY" >> ~/00-aascript.yaml
    echo "      nameservers:" >> ~/00-aascript.yaml
    echo "        addresses: [$PRIMARY_DNS, $SECONDARY_DNS]" >> ~/00-aascript.yaml
    echo "  version: 2" >> ~/00-aascript.yaml

    sudo cp ~/00-aascript.yaml /etc/netplan/00-aascript.yaml     
    sudo netplan apply
    
    echo "Netplan configuration applied successfully."

    echo "Netplan configuration skipped."
    
    # Wait for 10 seconds while the network initializes (with spinner animation)
    echo "Waiting for network to initialize..."
    spinner='|/-\'
    for i in {10..1}; do
        for j in {0..3}; do
            printf "\rTesting connectivity in %2d seconds... %c" $i "${spinner:$j:1}"
            sleep 0.25
        done
    done
    printf "\rTesting connectivity now...           \n"

    # Ping the gateway after waiting for the network to initialize
    if ping -c 4 $GATEWAY > /dev/null 2>&1; then
        echo "Network connection successful."
    else
        echo "Network connection failed - cannot reach gateway $GATEWAY"
        echo "Current network interfaces:"
        ip a
        echo "Please check the configuration in /etc/netplan/ directory"
        read -p "Press Enter to continue"
        exit 1
    fi
else
    echo "Netplan configuration skipped."
    echo "Note: You may need to manually configure network settings in /etc/netplan/"
fi

if [[ $VIEW_YAML == "y" ]]; then
    # Print the newly generated netplan config file
    if [[ -f /etc/netplan/00-aabash.yaml ]]; then # -f as a file test operator that tests to see if the file exists.
        cat /etc/netplan/00-aabash.yaml
        read -p "Press Enter to continue"
    else
        echo "Configuration file not found at /etc/netplan/00-aascript.yaml"
    fi
else
    echo "Skipping .yaml display."
fi

# Print the completetion of the configuration script.
if [[ $LAN_IP == 10.0.0.* ]]; then
    echo "Network configuration complete for subnet /$CIDR"
elif [[ $LAN_IP == 10.0.1.* ]]; then
    echo "Network configuration complete for subnet /$CIDR"	
elif [[ $LAN_IP == 10.0.2.* ]]; then
    echo "Network configuration complete for subnet /$CIDR"	
elif [[ $LAN_IP == 10.0.3.* ]]; then
    echo "Network configuration complete for subnet /$CIDR"	
elif [[ $LAN_IP == 192.168.*.* ]]; then
    echo "Network configuration complete for subnet /$CIDR"
fi

# Add system Proxy
export http_proxy="http://proxy-location@.company.com:port/"
export https_proxy="http://proxy-location@.company.com:port/"

# Update the system, install ssh server and disable system firewall.
sudo apt update
sudo apt install openssh-server -y
sudo ufw disable

# Check ssh status
sudo systemctl ssh status
