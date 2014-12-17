#!/bin/bash +x
 
# Source: http://www.gabsoftware.com/tips/automatically-reconnect-to-your-vpn-on-linux/
 
# Description:
# Make the script executable "chmod +x /path/to/the/script.sh
# Put the script in .profile or .bashrc so it can be run on user login:
# Example: echo "/path/to/the/script.sh start &" >> .bashrc
# The script can be bound to shortcut keys with these commands:
# /path/to/the/script.sh start # starts and monitors VPN connection
# /path/to/the/script.sh stop # stops the monitor and also the VPN connection
 
##########
# Config #
##########
 
# You can see those with "nmcli con show --active" command
VPN_NAME="VPN-NAME-HERE"
VPN_UID="VPN-UID-HERE"
 
# Delay in secconds
DELAY=300
 
# File path with write permission to the executing user to store script status information
LOG="/path/to/log/file.log"
 
# Enable/disable ping connection check
PING_CHECK_ENABLED=true
 
# Check IP/Hostname
CHECK_HOST="8.8.8.8"
 
# Configure DISPLAY variable for desktop notifications
DISPLAY=0.0
 
##################
# Implementation #
##################
 
if [[ $1 == "stop" ]]; then
	nmcli con down uuid $VPN_UID
 
	echo "VPN monitoring service STOPPED!"
	echo "$(date +%Y/%m/%d\ %H:%M:%S) -> VPN monitoring service STOPPED!" >> $LOG
	notify-send "VPN monitoring service STOPPED!"
	SCRIPT_FILE_NAME=`basename $0`
	PID=`pgrep -f $SCRIPT_FILE_NAME`
	kill $PID
elif [[ $1 == "start" ]]; then
	while [ "true" ]
	do
		VPNCON=$(nmcli con show --active | grep $VPN_NAME | cut -f1 -d " ")
		if [[ $VPNCON != $VPN_NAME ]]; then
			echo "$(date +%Y/%m/%d\ %H:%M:%S) -> Disconnected from $VPN_NAME, trying to reconnect..." >> $LOG
			(sleep 1s && nmcli con up uuid $VPN_UID)
		else
			echo "$(date +%Y/%m/%d\ %H:%M:%S) -> Already connected to $VPN_NAME!" >> $LOG
		fi
		sleep $DELAY
 
		if [[ $PING_CHECK_ENABLED = true ]]; then
			PINGCON=$(ping $CHECK_HOST -c2 -q -W 10 |grep "2 received")
			if [[ $PINGCON != *2*received* ]]; then
				echo "$(date +%Y/%m/%d\ %H:%M:%S) -> Ping check timeout ($CHECK_HOST), trying to reconnect..." >> $LOG
				(nmcli con down uuid $VPN_UID)
				(sleep 1s && nmcli con up uuid $VPN_UID)
			else
				echo "$(date +%Y/%m/%d\ %H:%M:%S) -> Ping check ($CHECK_HOST) - OK!" >> $LOG
			fi
		fi
	done
 
	echo "VPN monitoring service STARTED!"
	echo "$(date +%Y/%m/%d\ %H:%M:%S) -> VPN monitoring service STARTED!" >> $LOG
	notify-send "VPN monitoring service STARTED!"
else
	echo "$(date +%Y/%m/%d\ %H:%M:%S) -> Unrecognised command: $0 $@" >> $LOG
	echo "Please use $0 [start|stop]"
	notify-send "UNRECOGNIZED COMMAND" "VPN monitoring service could not recognise the command!"
fi
