# You can see those with "nmcli con show --active" command
VPN_NAME="VPN-NAME-HERE"
VPN_UID="VPN-UID-HERE"
 
# Delay in secconds
DELAY=60
PING_TIMEOUT=5
 
# File path with write permission to the executing user to store script status information
LOG="/path/to/log/file.log"
 
# Enable/disable ping connection check
PING_CHECK_ENABLED=true
 
# Check IPs/Hostnames
HOSTS=("8.8.8.8" "host.name")
 
# Configure DISPLAY variable for desktop notifications
DISPLAY=0.0
