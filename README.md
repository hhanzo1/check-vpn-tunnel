# About
Check if the VPN tunnel at a local pfsense is UP and **alert** when it's DOWN.

# Getting Started
## Prerequisites

* pfsense 2.7.2
* Uptime Kuma 

In Uptime Kuma create a Push Monitor and make a note of the Push URL.

## Installation
Download script to your pfsense home directory

```bash
wget https://github.com/hhanzo1/check-tunnel/blob/main/check-vpn-tunnel.sh
chmod +x script.sh
```

Update the script with your tunnel name (ie. ovpnc1 or ovpnc2) and the Uptime Kuma Push URL.

# Usage
Test the script is running as expected by running manually, then scheduled via cron.

```bash
# Run every minute
* * * * * /home/[USERID]/check-tunnel.sh
```

# Acknowledgments
* [pfsense](https://www.pfsense.org/)
* [Uptime Kuma](https://github.com/louislam/uptime-kuma)
