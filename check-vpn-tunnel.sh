#!/bin/sh

## pfSense Uptime Kuma OpenVPN Tunnel Monitor
#
# Run this script on pfSense in your home directory and schedule via cron
#
#  Check for an IP on the OpenVPN tunnel interface
#  Ping the interface and store the value
#  Send the result to the Uptime Kuma Push URL
#
# run every minute
# * * * * * /home/[USERID]/check-tunnel.sh
#

# Provide the pfSense OpenVPN Tunnel Interface name
TUNNEL_INTERFACE="ovpnc1"

# Provide the base Uptime Kuma Push URL
BASE_URL="https://uptimekuma.yourdomain.com/api/push/tJNlsb6wzj"

# Set up logging
LOG_FILE="/home/[USERID]/check-vpn-tunnel.log"
MAX_LOG_SIZE=1048576 # 1 MB

# Function to log messages
log() {
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$TIMESTAMP $1" >> "$LOG_FILE"
}

# Function to check if log file exists
check_log_exists() {
    if [ ! -f "$LOG_FILE" ]; then
        touch "$LOG_FILE"
    fi
}

# Function to check log file size and delete if exceeds limit
check_log_size() {
    if [ -z "$LOG_FILE" ]; then
        echo "LOG_FILE is not set."
        return 1
    fi

    if [ -z "$MAX_LOG_SIZE" ]; then
        echo "MAX_LOG_SIZE is not set."
        return 1
    fi

    FILESIZE=$(du -B 1 "$LOG_FILE" | cut -f1)
    if [ "$FILESIZE" -gt "$MAX_LOG_SIZE" ]; then
        rm -f "$LOG_FILE"
        echo "Deleted $LOG_FILE due to size limit reached."
        touch "$LOG_FILE"
    fi
}

# Main loop
while true; do
    check_log_exists
    check_log_size
    log "START"
    log "TUNNEL_INTERFACE: $TUNNEL_INTERFACE"
    log "BASE_URL: $BASE_URL"

    # Check for the presense of an IP on the tunnel interface
    if ifconfig $TUNNEL_INTERFACE | grep -q 'inet '; then
        log "OpenVPN tunnel status: UP"
        TUNNEL_STATUS='up'
    else
        log "OpenVPN tunnel status: DOWN"
        TUNNEL_STATUS='down'
    fi

    # Get the TUNNEL IP address
    TUNNEL_IP=$(ifconfig $TUNNEL_INTERFACE | awk '/inet / {print $2}')
    log "Tunnel IP: $TUNNEL_IP"

    # Perform the ping test and extract the average ping time
    PING_RESULT=$(ping -c 1 "$TUNNEL_IP" 2>/dev/null | grep 'time=' | awk -F'time=' '{ print $2 }' | awk '{ print $1 }')
    if [ -z "$PING_RESULT" ]; then
        PING_RESULT='N/A'
    fi

    # Construct the request URL with the tunnel status and dynamic ping value
    URL="${BASE_URL}?status=${TUNNEL_STATUS}&msg=OK&ping=${PING_RESULT}"
    log "FULL_URL: $URL"

    # Execute the HTTP request
    RESPONSE=$(curl --max-time 5 -s -o /dev/null -w "%{http_code}" "$URL")
    if [ $? -eq 0 ]; then
        log "CURL command executed. Response status: $RESPONSE"
    else
        log "Failed to execute CURL command."
    fi

done
