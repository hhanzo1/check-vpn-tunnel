# About
Check if a pfsense VPN tunnel is UP and **alert** when it's DOWN.

# Getting Started
## Prerequisites

* pfsense 2.7.2
* Uptime Kuma 

In Uptime Kuma create a Push Monitor and note the Push URL.

## Installation
Download script to your pfsense home directory
```bash
wget https://github.com/hhanzo1/check-tunnel/blob/main/check-vpn-tunnel.sh
chmod +x check-vpn-tunnel.sh
```
Update the script with the tunnel name (ie. ovpnc1 or ovpnc2) and the Uptime Kuma Push URL.

# Usage
Run the script manually to check it is working as expected, then scheduled via cron.

## Enable the check script
```bash
# Run every minute
* * * * * /home/[USERID]/check-vpn-tunnel.sh
```
If the Push URL does not receive a HTTP request within the Heart Beat internal (default 60 seconds), an alert can be triggered.

## View Badges
Status and Uptime [Uptime Kuma Badges](https://github.com/louislam/uptime-kuma/wiki/Badge) can be configured.

![tunnel status](https://uptime.netwrk8.com/api/badge/12/status)
![tunnel uptime](https://uptime.netwrk8.com/api/badge/12/uptime)
![tunnel uptime 30d](https://uptime.netwrk8.com/api/badge/12/uptime/720?label=Uptime(30d)&labelSuffix=d)

# Acknowledgments
* [pfsense](https://www.pfsense.org/)
* [Uptime Kuma](https://github.com/louislam/uptime-kuma)
