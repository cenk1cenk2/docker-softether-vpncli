```
name:         | softether-vpncli
compiler:     | docker-compose + dockerfile
version:      | v2.1, 20190319
```

## Description:

Creates a Softether instance to connect to the defined connection in the imported VPN file.
MTU is reduced to 1200 because of this is intended for internal networking.

## Setup

**Fast Deploy Ready**
* `cp internalconn.vpn` to root directory for automatic connection to that setting.
* `chmod +x init-env.sh && ./init-env.sh && nano .env` for configuration.