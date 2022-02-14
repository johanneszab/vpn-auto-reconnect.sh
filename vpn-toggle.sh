#!/bin/bash +x

# Source: http://www.gabsoftware.com/tips/automatically-reconnect-to-your-vpn-on-linux/

# Description:
# Make the script executable "chmod +x /path/to/the/script.sh
# Put the script in .profile or .bashrc so it can be run on user login:
# Example: echo "/path/to/the/script.sh start &" >> .bashrc
# The script can be bound to shortcut keys with these commands:
# /path/to/the/script.sh # toggles your first set VPN on and off

##########
# Config #
##########

source $(dirname $(readlink -f $0))/vpn-config.sh

##################
# Implementation #
##################


vpn_index=0
VPN_UID=${VPN_UIDS[$vpn_index]}

if [[ $(nmcli con show --active | grep vpn | awk '{print $2}') != $VPN_UID ]]; then
  nmcli con up uuid $VPN_UID
else
  nmcli con down uuid $VPN_UID
fi
