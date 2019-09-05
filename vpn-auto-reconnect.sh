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

source $(dirname $0)/vpn-config.sh

##################
# Implementation #
##################

vpn_index=0
vpns=${#VPN_UIDS[@]}
VPN_UID=${VPN_UIDS[$vpn_index]}

function next_vpn(){
  VPN_UID=${VPN_UIDS[$vpn_index]}
  vpn_index=$((($vpn_index + 1) % $vpns))
}

function logStuff {
  echo "$1"
  echo "$1" >> $LOG
}

function resetVPN {
  logStuff "$(date +%Y/%m/%d\ %H:%M:%S) -> Trying to reconnect..."
  (nmcli con down uuid $VPN_UID)
  next_vpn
  connectToVPN
}

function connectToVPN {
  out="$(date +%Y/%m/%d\ %H:%M:%S) -> "
  if [ -n "$(nmcli con show --active | grep $DEVICE)" ]; then
    out+="Connecting..."
    logStuff "$out"
    (sleep 1s && nmcli con up uuid $VPN_UID)
  else
    out+="No active network connection"
    logStuff "$out"
  fi
}

function pingTest {
  # $1 = host
  # $2 = reconnect?
  PINGCON=$(ping $1 -c 2 -q -W $PING_TIMEOUT | grep "2 received")
  if [[ $PINGCON != *2*received* ]]; then
    logStuff "$(date +%Y/%m/%d\ %H:%M:%S) -> Ping check timeout ($1)..."
    if [[ $2 ]]; then
      resetVPN
      host_pings_needed=false
    fi
  else
    # echo "$(date +%Y/%m/%d\ %H:%M:%S) -> Ping check ($1) - OK!" >> $LOG
    host_pings_needed=false
  fi
}

if [[ $1 == "stop" ]]; then
  nmcli con down uuid $VPN_UID
  echo "VPN monitoring service STOPPED!"
  echo "$(date +%Y/%m/%d\ %H:%M:%S) -> VPN monitoring service STOPPED!" >> $LOG
  notify-send "VPN monitoring service STOPPED!"
  SCRIPT_FILE_NAME=`basename $0`
  PID=`pgrep -f $SCRIPT_FILE_NAME`
  kill $PID
elif [[ $1 == "start" ]]; then
  while [ "true" ]; do
    VPNCON=$(nmcli con show --active | grep vpn | awk '{print $2}')
    if [[ $VPNCON != $VPN_UID ]]; then
      logStuff "$(date +%Y/%m/%d\ %H:%M:%S) -> Disconnected from $VPN_UID, trying to reconnect..."
      connectToVPN
    # else
      # echo "$(date +%Y/%m/%d\ %H:%M:%S) -> Already connected to $VPN_UID!" >> $LOG
    fi
    sleep $DELAY
    if [[ $PING_CHECK_ENABLED = true ]]; then
      i=0
      host_length=${#HOSTS[@]}
      host_pings_needed=true
      while $host_pings_needed; do
        host=${HOSTS[i]}
        i=$(($i+1))
        if [ $i -eq $host_length ]; then
          pingTest $host true
        else 
          pingTest $host
        fi
      done
      vpn_index=0 # Prefer first
    fi
  done

  logStuff "$(date +%Y/%m/%d\ %H:%M:%S) -> VPN monitoring service STARTED!"
  notify-send "VPN monitoring service STARTED!"
else
  logStuff "$(date +%Y/%m/%d\ %H:%M:%S) -> Unrecognised command: $0 $@"
  echo "Please use $0 [start|stop]"
  notify-send "UNRECOGNIZED COMMAND" "VPN monitoring service could not recognise the command!"
fi
