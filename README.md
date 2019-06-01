```
name:         | softether-vpncli
compiler:     | docker-compose + dockerfile
version:      | v2.3, 20190601
```
# softether-vpncli@docker

## Description:

A Docker Container that creates a Softether Client instance to connect to the defined connection in the imported VPN file with an option to enable Samba File Sharing server to internally share files through VPN.

### Features
* S6-Overlay implemented. So in every new connection, a new virtual adapter will be created and after the connection is terminated, it will be removed gracefully.
* The connection will be checked every defined seconds to X.X.X.1 as the server to be sure of that it is still alive and if the server can not be reached it will restart the whole process thanks to S6-Overlay in case of hangs.
* Ability to enable embedded Samba Server if you desire to share files between devices in a private network.
* Internal connection switch, which will reduce the MTU of the virtual ethernet adapter to 1200 so that Samba shares through the internet will not be slow due to the overhead of the packets with VPN data and instead of trying to split into multiple packets.
* Always builds the latest version from the official GitHub repository of SoftEther. The base operating system is fixed for Alpine 3.8.4 for now, since for the edge version there were some problems and I choose stability over the edge version which doesn't matter.
* ~70MB image size, ~15-20MB RAM Usage while standalone.

## Setup

Clone the GitHub repository to get an environmental variable initiation script and preconfigured docker-compose file if you wish to get a head start.

### Softether VPN Connection Settings
* `cp defaulconn.vpn` to root directory for automatic connection to that setting.
* `chmod +x init-env.sh && ./init-env.sh && nano .env` for configuration.

### Internal Samba Server Connection if you choose to enable
* `nano docker-compose.yml` to edit volume mounts matching to mounts in enviromental variables.
* `chmod +x init-env.sh && ./init-env.sh && nano .env` for configuration.

### Manual Setup
If it is not possible to run the shell script that will generate the default .env file or running it directly from the command line the explanation for all the variables can be found below.

Only mandatory variables are $CONNNAME and $SLEEPTIME. But they both have default values to fall back to if you don't want to define any variables while running on the command line.

#### Example Setup
```docker run -d cenk1cenk2/softether-vpncli -v ./connectionname.vpn:/defaultconn.vpn```
will connect to defined connection in connectionname.vpn, it will only connect the *container* to the VPN.

```docker run -d cenk1cenk2/softether-vpncli -v ./connectionname.vpn:/defaultconn.vpn --cap-add NET_ADMIN```
will connect to defined connection in connectionname.vpn, it will *also connect your host PC* __if running Linux__ to the VPN as well.

```
docker run -d cenk1cenk2/softether-vpncli \
-v ./connectionname.vpn:/defaultconn.vpn \
-v /sharePath:/share/path1 \
-v /anotherShare:/share/path2 \
--network host --privileged \
-e INTCONN=true \
-e SAMBAENABLE=true \
-e SRVNAME=FILESHARESERVERNAME \
-e USERS=shareaccess;password:secondshare;password \
-e share;/share/path1;no;no;no;shareaccess:share2;/share/path2;no;no;no;secondshare
```
will connect to defined connection in connectionname, and create 2 shasres at paths /share/path1 and /share/path2 giving access to different users for different paths. The file server name will be \\\\FILESHARESERVERNAME and the MTU will be set to 1200 to enable users to use Samba over VPN connection. You can use `-p 139:139 -p 445:445` to passthrough Samba Server ports instead of `--network host --privileged` if you can not use the host mode network connection. 
**Unfortunately, CAP_ADD is not enough privileges this container to function in host mode. So until any one knows why it has to run as privileged when you are in network host mode.**

#### Enviromental Variables File with Explanation
```
##
# GENERAL SETTINGS
##
# TIMEZONE
# Leave empty or comment out if it is not used.
TZ=
##
# SOFTETHER VPN CLIENT SETTINGS
##
# VPN file relative path. Exported .vpn file name which must include the authentication parameters as well
# Mandatory, Default defaultconn
CONNNAME=defaultconn
# The script will check VPN connection periodically please define the period in seconds between checks.
# Mandatory, Default 3600
SLEEPTIME=3600
# Static MAC address.
# Leave empty or comment out if it is not used.
MACADD=
# Set true for internal connection to set mtu 1200 or 1500.
# Leave empty or comment out if it is not used.
INTCONN=
##
# If your network gateway address of the VPN server is different than 1, it will override it.
# Leave empty or comment out if it is not used.
NETWORKGATEWAY=
# EMBEDDED SAMBA SERVER SETTINGS
##
# Enable or disable internal Samba server.
# Leave empty or comment out if it is not used.
SAMBAENABLE=
# Server WINS identification name
# Leave empty or comment out if it is not used.
SRVNAME=
# USERS: required arg: "<username>;<passwd>"
# <username> for user
# <password> for user
# for rest of the data; to obtain default value, just leave blank
# [ID] for user
# [group] for user
# multiple user format: example1;password:example2;password
# Leave empty or comment out if it is not used.
USERS=
# MOUNTS: Configure a share
# required arg: "<name>;</path>"
# <name> is how it's called for clients
# <path> path to share
# for rest of the data; to obtain default value, just leave blank
# [browsable] default:'yes' or 'no'
# [readonly] default:'yes' or 'no'
# [guest] allowed default:'yes' or 'no'
# [users] allowed default:'all' or list of allowed users
# [admins] allowed default:'none' or list of admin users
# [writelist] list of users that can write to a RO share
# [comment] description of share
# multiple mount format: example1 private share;/example1;no;no;no;example1:example2 private share;/example2;no;no;no;example2
# Leave empty or comment out if it is not used.
MOUNTS=
# WORKGROUP NAME
# Leave empty or comment out if it is not used.
WORKGROUPNAME=WORKGROUP
```
