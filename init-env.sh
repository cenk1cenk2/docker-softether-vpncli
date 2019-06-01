#!/bin/bash

## Refer to the GitHub repository for configuration and problems.
## Cenk Kilic <cenk@kilic.dev>
## https://srcs.kilic.dev/

echo "Initiating .env file for given container."

if [ ! -f ./.env ]; then
    echo ".env file not found initiating."
    FILEFOUND=false
else
    echo -n ".env file already initiated. You want to override? [y/N]: "
    read -r OVERRIDE
    if echo ${OVERRIDE::1} | grep -iqF "y"; then
        echo "Will rewrite the .env file with the empty one."
        FILEFOUND=false
    else
        echo "Not doing anything."
        exit
    fi
fi

FILENAME=.env
# Container specific initiate.
echo "" > $FILENAME
echo "##" >> $FILENAME
echo "# GENERAL SETTINGS" >> $FILENAME
echo "##" >> $FILENAME
echo "# TIMEZONE" >> $FILENAME
echo "# Leave empty or comment out if it is not used." >> $FILENAME
echo "TZ=" >> $FILENAME
echo "##" >> $FILENAME
echo "# SOFTETHER VPN CLIENT SETTINGS" >> $FILENAME
echo "##" >> $FILENAME
echo "# VPN file relative path. Exported .vpn file name which must include the authentication parameters as well" >> $FILENAME
echo "# Mandatory, Default defaultconn" >> $FILENAME
echo "CONNNAME=defaultconn" >> $FILENAME
echo "# The script will check VPN connection periodically please define the period in seconds between checks." >> $FILENAME
echo "# Mandatory, Default 3600" >> $FILENAME
echo "SLEEPTIME=3600" >> $FILENAME
echo "# Static MAC address." >> $FILENAME
echo "# Leave empty or comment out if it is not used." >> $FILENAME
echo "MACADD=" >> $FILENAME
echo "# Set true for internal connection to set mtu 1200 or 1500." >> $FILENAME
echo "# Leave empty or comment out if it is not used." >> $FILENAME
echo "INTCONN=" >> $FILENAME
echo "##" >> $FILENAME
echo "# If your network gateway address of the VPN server is different than 1, it will override it." >> $FILENAME
echo "# Leave empty or comment out if it is not used." >> $FILENAME
echo "NETWORKGATEWAY=" >> $FILENAME
echo "# EMBEDDED SAMBA SERVER SETTINGS" >> $FILENAME
echo "##" >> $FILENAME
echo "# Enable or disable internal Samba server." >> $FILENAME
echo "# Leave empty or comment out if it is not used." >> $FILENAME
echo "SAMBAENABLE=" >> $FILENAME
echo "# Server WINS identification name" >> $FILENAME
echo "# Leave empty or comment out if it is not used." >> $FILENAME
echo "SRVNAME=" >> $FILENAME
echo "# USERS: required arg: \"<username>;<passwd>\"
# <username> for user
# <password> for user
# [ID] for user
# [group] for user
# multiple user format: example1;password:example2;password" >> $FILENAME
echo "# Leave empty or comment out if it is not used." >> $FILENAME
echo "USERS=" >> $FILENAME
echo "# MOUNTS: Configure a share
# required arg: \"<name>;</path>\"
# <name> is how it's called for clients
# <path> path to share
# NOTE: for the default value, just leave blank
# [browsable] default:'yes' or 'no'
# [readonly] default:'yes' or 'no'
# [guest] allowed default:'yes' or 'no'
# [users] allowed default:'all' or list of allowed users
# [admins] allowed default:'none' or list of admin users
# [writelist] list of users that can write to a RO share
# [comment] description of share
# multiple mount format: example1 private share;/example1;no;no;no;example1:example2 private share;/example2;no;no;no;example2" >> $FILENAME
echo "# Leave empty or comment out if it is not used." >> $FILENAME
echo "MOUNTS=" >> $FILENAME
echo "# WORKGROUP NAME" >> $FILENAME
echo "# Leave empty or comment out if it is not used." >> $FILENAME
echo "WORKGROUPNAME=WORKGROUP" >> $FILENAME
