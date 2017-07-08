vpn-auto-reconnect.sh
==========

A simple bash script for autoreconnect to OpenVPN via NetworkManager command-line (mncli).

Source: http://www.gabsoftware.com/tips/automatically-reconnect-to-your-vpn-on-linux/

Fork from: https://gist.github.com/antoniy/f925ae55410a092c9e75/ with changes for nmcli v0.9.10. Script tested on fedora 21 with airvpn (OpenVPN).
 
__Usage:__

1. Make the script executable "_chmod +x /path/to/the/vpn-auto-reconnect.sh_"

2. You have to set your openvpn _connection name_ and openvpn _uuid_ in the config section of the script. Type "_nmcli con show_" to get these values.

3. _vpn-auto-reconnect.sh stop_ -- stops the monitor and also the VPN connection 

4. _vpn-auto-reconnect.sh start_ -- starts and monitors VPN connection

You may want to to adjust the _DELAY_ time between ping checks, and also the "*-W timeout*" of the ping command in line _62_ if the timeout is too agressive.

A summary of nmcli command changes for version v0.9.10 can be found here: https://wiki.gnome.org/Projects/NetworkManager/nmcli
