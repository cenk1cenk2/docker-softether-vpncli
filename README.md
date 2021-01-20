# cenk1cenk2/softether-vpncli

[![Build Status](https://drone.kilic.dev/api/badges/cenk1cenk2/docker-softether-vpncli/status.svg)](https://drone.kilic.dev/cenk1cenk2/softether-vpncli) [![Docker Pulls](https://img.shields.io/docker/pulls/cenk1cenk2/softether-vpncli)](https://hub.docker.com/repository/docker/cenk1cenk2/softether-vpncli) [![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/cenk1cenk2/softether-vpncli)](https://hub.docker.com/repository/docker/cenk1cenk2/softether-vpncli) [![Docker Image Version (latest by date)](https://img.shields.io/docker/v/cenk1cenk2/softether-vpncli)](https://hub.docker.com/repository/docker/cenk1cenk2/softether-vpncli) [![GitHub last commit](https://img.shields.io/github/last-commit/cenk1cenk2/softether-vpncli)](https://github.com/cenk1cenk2/softether-vpncli)

<!-- toc -->

- [Description](#description)
- [Features](#features)
  - [Resource-Efficient](#resource-efficient)
  - [Up-to-Date](#up-to-date)
  - [Version Tracking](#version-tracking)
  - [Always Alive](#always-alive)
  - [Graceful Shutdown](#graceful-shutdown)
  - [Internal File Sharing](#internal-file-sharing)
  - [Internal Connections](#internal-connections)
- [Environment Variables](#environment-variables)
  - [General Environment Variables](#general-environment-variables)
  - [SoftEther Client Environment Variables](#softether-client-environment-variables)
  - [Samba Environment Variables](#samba-environment-variables)
    - [Users Format](#users-format)
    - [Mounts Format](#mounts-format)
- [Deploy](#deploy)
  - [With docker-compose](#with-docker-compose)
  - [With docker](#with-docker)

<!-- tocstop -->

---

## Description

SoftEther VPN is free open-source, cross-platform, multi-protocol VPN client and VPN server software, developed as part of Daiyuu Nobori's master's thesis research at the University of Tsukuba. VPN protocols such as SSL VPN, L2TP/IPsec, OpenVPN, and Microsoft Secure Socket Tunneling Protocol are provided in a single VPN server.

A Docker Container that creates a Softether Client instance to connect to the defined connection in the imported VPN file with an option to enable Samba file sharing server to internally share files through VPN.

[Read more](https://www.softether.org/) about SoftEther in the official documentation.

## Features

### Resource-Efficient

Build on top of Alpine linux as base, ~70MB image size, ~15-20MB RAM Usage while standby.

### Up-to-Date

This repository is always up to date tracking the [default](https://github.com/SoftEtherVPN/SoftEtherVPN) repository of SoftEther VPN on GitHub. It checks the main repository monthly, since there is not frequent updates anymore, and if a new release has been matched it will trigger the build process.

It always builds the application from the source, and while doing that the dependencies will also be updated.

### Version Tracking

The Docker images are given matching versions to the original repository. If a update has been made on this repository itself, it will append a suffix to the original version.

### Always Alive

[s6-overlay](https://github.com/just-containers/s6-overlay) is implemented to check whether everything is working as expected and do a sanity check with pinging the main VPN server periodically as well as checking the health of Samba file client if it is enabled.

A environment variable, namely `SLEEPTIME` can be set in seconds to determine the period of this check.

If the periodic check fails, it will go in to graceful shutdown mode and clear any residue like tap devices, virtual network adapters and such, so it can restart from scratch.

### Graceful Shutdown

At shutdown or crashes, the container cleans up all the created veth interfaces, tap devices and undoes all the system changes.

### Internal File Sharing

Ability to enable embedded Samba Server if you desire to share files between devices in a private network.

### Internal Connections

Internal connection switch, which will reduce the MTU of the virtual ethernet adapter to 1200 so that Samba shares through the internet will not be slow due to the overhead of the packets with VPN data and instead of trying to split into multiple packets.

On the other end of the devices, if VPN adapter MTU is set to 1200, it will work its best. This is due to the VPN overhead of the packages and general network MTU being 1500.

## Environment Variables

### General Environment Variables

| Environment Variable | Description                                                                       | Default Value |
| -------------------- | --------------------------------------------------------------------------------- | ------------- |
| `TZ`                 | Timezone for the server.                                                          |               |
| `LOG_LEVEL`          | Log level for the scripts. Can be: [ SILENT, ERROR, WARN, LIFETIME, INFO, DEBUG ] | INFO          |
| `SLEEPTIME`          | The time in seconds between checks of whether everything is working.              | 3600          |

### SoftEther Client Environment Variables

| Environment Variable | Description                                                                    | Default Value |
| -------------------- | ------------------------------------------------------------------------------ | ------------- |
| `CONNNAME`           | Name of the connection file which should be mounted with the same name on `/`. | defaultconn   |
| `MACADD`             | Give a MAC address to the virtual network adapter.                             |               |
| `INTCONN`            | To set the MTU to 1200 for improving the performance between VPN devices.      |               |
| `NETWORKGATEWAY`     | If the network gateway uses a different value.                                 | 1             |

### Samba Environment Variables

| Environment Variable | Description                                                                          | Default Value |
| -------------------- | ------------------------------------------------------------------------------------ | ------------- |
| `SAMBAENABLE`        | Enable the internal samba server, set to anything.                                   |               |
| `SRVNAME`            | WINS identification name.                                                            |               |
| `USERS`              | [username];[passwd];[uid];[gid]                                                      |               |
| `MOUNTS`             | [name];[path];[browsable];[readonly];[guest];[users];[admins];[writelist];[comment]] |               |
| `WORKGROUPNAME`      | Workgroup name to join.                                                              | WORKGROUP     |

**`USERS` and `MOUNTS` can have multiple values with colon separated (`:`) values.**

#### Users Format

| Value    | Description                | Default | Options | Optional |
| -------- | -------------------------- | ------- | ------- | -------- |
| username | Samba username for login.  |         |         | no       |
| password | Samba password for login.  |         |         | no       |
| uid      | User ID for created user.  |         |         | yes      |
| gid      | Group ID for created user. |         |         | yes      |

**Example:**

> ```text
> example1;password:example2;password
> ```

#### Mounts Format

| Value     | Description                                                                  | Default | Options | Optional |
| --------- | ---------------------------------------------------------------------------- | ------- | ------- | -------- |
| name      | Name to display on the share.                                                |         |         | no       |
| path      | Internal container path to share.                                            |         |         | no       |
| browsable | Whether the share is browsable.                                              | yes     | yes, no | yes      |
| readonly  | Whether the share is readonly.                                               | yes     | yes, no | yes      |
| guest     | Whether the share is available to guests.                                    | yes     | yes, no | yes      |
| users     | Determine the users that have the ability have access. Separated by commas.  | all     |         | yes      |
| admins    | Determine the admins that have the ability have access. Separated by commas. | none    |         | yes      |
| writelist | Users that can write on read-only share                                      |         |         | yes      |
| comment   | Comment on the share                                                         |         |         | yes      |

**Example:**

> ```text
> 'private share';/example1;no;no;no;example2:'very private share';/example2;no;no;no;example2
> ```

## Deploy

Clone the GitHub repository to get an environmental variable initiation script and preconfigured docker-compose file if you wish to get a head start. Advised way to run the setup is with docker-compose but it can be run with a long command with docker run.

**Unfortunately, CAP_ADD is not enough privileges this container to function in host mode. It has to create virtual adapter in the network namespace but some additional things are also performed.**

### With docker-compose

```bash
# Clone repo
git clone git@github.com:cenk1cenk2/softether-vpncli.git

# Initiate environment variables for convienence
chmod +x init-env.sh

./init-env.sh

# Edit docker-compose and env file for adding samba mounts and server settings
nvim .env

# Copy your profile
cp internalconn.vpn ./internalconn.vpn # Has a default
```

### With docker

```bash
docker run -d \
--name softether-vpncli \
-v $(pwd)/defaultconn.vpn:/defaultconn.vpn \
--network bridge \
--privileged \
cenk1cenk2/softether-vpncli
```

- Will connect to defined connection in "connectionname.vpn", it will only connect the _container_ to the VPN.

```bash
docker run -d \
--name softether-vpncli \
-v $(pwd)/defaultconn.vpn:/defaultconn.vpn \
--network host \
--privileged \
cenk1cenk2/softether-vpncli
```

- Will connect to defined connection in "connectionname.vpn", it will _also connect your host PC_ **if running Linux** to the VPN as well.

```bash
docker run -d \
--name softether-vpncli \
-v $(pwd)/connectionname.vpn:/defaultconn.vpn \
-v $(pwd)/sharePath:/share/path1 \
-v /files/anotherShare:/share/path2 \
--network host --privileged \
-e INTCONN=true \
-e SAMBAENABLE=true \
-e SRVNAME=FILESHARESERVERNAME \
-e USERS=shareaccess;password:secondshare;password \
-e share;/share/path1;no;no;no;shareaccess:share2;/share/path2;no;no;no;secondshare \
cenk1cenk2/softether-vpncli
```

- Will connect to defined connection in "connectionname.vpn"
- Create 2 shares at paths "/share/path1" and "/share/path2 giving access to different users for different paths.
- The file server name will be "\\\\FILESHARESERVERNAME".
- MTU will be set to 1200 to enable users to use Samba over VPN connection.
- You can use `-p 139:139 -p 445:445` to passthrough Samba Server ports instead of `--network host --privileged` if you can not use the host mode network connection.
