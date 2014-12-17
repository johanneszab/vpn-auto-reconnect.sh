vpn-auto-reconnect.sh
=====================

A simple bash script for autoreconnect to OpenVPN via NetworkManager 
command-line (mncli).

Source: http://www.gabsoftware.com/tips/automatically-reconnect-to-your-vpn-on-linux/
Fork from: https://gist.github.com/antoniy/f925ae55410a092c9e75/ with changes for
nmcli v0.9.10. Script tested on fedora 21 with airvpn (OpenVPN).
 
Description:
Make the script executable "chmod +x /path/to/the/vpn-auto-reconnect.sh

vpn-auto-reconnect.sh.sh start # starts and monitors VPN connection
vpn-auto-reconnect.sh.sh stop # stops the monitor and also the VPN connection 

You have to set your openvpn connection name and openvpn uuid in the config 
section of the script. Type "nmcli con show" to get these values.

You may want to to adjust the DELAY time between ping checks, and also the 
"-W timeout" of the ping command in line 62 if the timeout is too agressive.

A summary of nmcli command changes for version v0.9.10 can be found here:
https://wiki.gnome.org/Projects/NetworkManager/nmcli
