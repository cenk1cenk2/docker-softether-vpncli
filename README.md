```
name:         | softether-vpncli-int
compiler:     | docker-compose + dockerfile
version:      | v2.0, 20190318
```

## Description:

Creates a Softether instance to connect to the defined connection in the imported VPN file.
MTU is reduced to 1200 because of this is intended for internal networking.

## Setup

* `cp internalconn.vpn` to root directory for automatic connection to that setting.
* `chmod +x init-env.sh && nano init-env.sh` for configuration.