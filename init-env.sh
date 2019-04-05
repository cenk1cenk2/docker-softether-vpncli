#!/bin/bash

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
echo "TZ=Europe/Vienna" > $FILENAME
echo "#" >> $FILENAME
echo "# SOFTETHER VPN CLIENT SETTINGS" > $FILENAME
echo "#" >> $FILENAME
echo "# Adapter Name can take the form of vpn[2-...] so only a number is written" >> $FILENAME
echo "ADAPTERNAME=" >> $FILENAME
echo "# Static MAC address." >> $FILENAME
echo "# Leave empty or comment out if it is not used." >> $FILENAME
echo "MACADD=00:00:00:00:00:00" >> $FILENAME
echo "# Exported .vpn file name which must include the authentication parameters as well" >> $FILENAME
echo "CONNNAME=internalconn" >> $FILENAME
echo "# Set true for internal connectione to set mtu 1200 or 1500." >> $FILENAME
echo "# Leave empty or comment out if it is not used." >> $FILENAME
echo "INTCONN=" >> $FILENAME
echo "#" >> $FILENAME
echo "# EMBEDDED SAMBA SERVER SETTINGS" >> $FILENAME
echo "#" >> $FILENAME
echo "# Leave empty or comment out if it is not used." >> $FILENAME
echo "SAMBAENABLE=" >> $FILENAME
echo "SRVNAME=" >> $FILENAME
echo "# USERS: required arg: \"<username>;<passwd>\"
# <username> for user
# <password> for user
# [ID] for user
# [group] for user
# multiple user format: example1;badpass:example2;badpass" >> $FILENAME
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
echo "MOUNTS=" >> $FILENAME
echo "WORKGROUPNAME=WORKGROUP" >> $FILENAME
