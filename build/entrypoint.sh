#!/usr/bin/env bash

set -o nounset
# SOFTETHER START
echo "Starting Softether Client..."
## enable ipv4 forwarding
echo "Enable IPv4 forwarding..."
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
## start vpnclient
echo "Starting client daemon..."
setcap 'cap_net_bind_service=+ep' /usr/local/bin/vpnclient
sleep 2
/usr/local/bin/vpnclient start
## Delete older interfaces veth*
for veth in $(ifconfig | grep "^veth" | cut -d' ' -f1); do ip link delete $veth ; done
## create nic and connect to vpn
echo "Creating Virtual NIC..."
/usr/bin/expect<<EOD
set timeout -1
spawn /usr/local/bin/vpncmd
expect "Select 1, 2 or 3: "
send "2\r"
expect "Hostname of IP Address of Destination: "
send "\r"
expect "VPN Client>"
send "nicdelete\r"
expect "Virtual Network Adapter Name: "
send "vpn\r"
expect "VPN Client>"
send "niccreate\r"
expect "Virtual Network Adapter Name: "
send "vpn\r"
expect "VPN Client>"
send "accountdelete internalconn\r"
expect "VPN Client>"
send "accountimport\r"
expect "Import Source File Name: "
send "/usr/bin/internalconn.vpn\r"
expect "VPN Client>"
send "nicsetsetting vpn\r"
expect "MAC Address to Set: "
send "$MACADD\r"
expect "VPN Client>"
send "nicupgrade vpn\r"
expect "VPN Client>"
send "exit\r"
EOD
echo "Restart NIC Adapter"
/usr/local/bin/vpnclient stop
sleep 2
/usr/local/bin/vpnclient start
sleep 3
echo "Reconnect with desired MAC settings"
/usr/bin/expect<<EOD
set timeout -1
spawn /usr/local/bin/vpncmd
expect "Select 1, 2 or 3: "
send "2\r"
expect "Hostname of IP Address of Destination: "
send "\r"
expect "VPN Client>"
send "accountconnect internalconn\r"
expect "VPN Client>"
send "exit\r"
EOD
sleep 3
## Get ip after connection
echo "\n"
echo "Renewing ethernet adapter..."
sysctl -p
echo "Set MTU to 1200."
ifconfig vpn_vpn mtu 1200
sleep 3
echo "Tailing log files..."
tail -F /usr/local/libexec/softether/vpnclient/*_log/*.log &
sleep 2
ifconfig vpn_vpn down
sleep 2
ifconfig vpn_vpn up
while pgrep vpnclient > /dev/null;:
do
	echo "Requesting IP from VPN server..."
    dhclient vpn_vpn
    echo "IP address obtained..."
    ip addr show vpn_vpn
	sleep 3600
done