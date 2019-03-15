```
name:         | softether-vpncli-int
compiler:     | docker-compose + dockerfile
version:      | v1.4, 20190315
```

## Description:

Creates a Softether instance to connect to the defined connection in the "./internalconn.vpn". 
MTU is reduced to 1200 because of this is intended for internal networking.

## Setup

* `cp internalconn.vpn` to root directory for automatic connection to that setting.
* `nano .env` for changing static MAC Address.