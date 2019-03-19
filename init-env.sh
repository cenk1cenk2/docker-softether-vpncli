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
echo "# Static MAC address." >> $FILENAME
echo "# Leave empty or comment out if it is not used." >> $FILENAME
echo "MACADD=00:00:00:00:00:00" >> $FILENAME
echo "# Exported .vpn file name which must include the authentication parameters as well" >> $FILENAME
echo "CONNNAME=internalconn" >> $FILENAME
echo "# Set true for internal connectione to set mtu 1200 or 1500." >> $FILENAME
echo "# Leave empty or comment out if it is not used." >> $FILENAME
echo "INTCONN=" >> $FILENAME
