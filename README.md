# lightningnetwork/lnd docker container
## Getting started
This docker container is a tiny **alpine/adm64** compatible container, automatically built from Official lnd team releases on https://github.com/lightningnetwork/lnd/releases.

### Configuration File
No configuration file is needed as you can add parameters to the "command" docker parameter. To see all options available, see reference file https://github.com/lightningnetwork/lnd/blob/master/sample-lnd.conf .

If you wish to use a configuration file, change volume configuration to map your existing configuration file path.

### Persistance
A persistant volume is created on the fly, linked to /home/lnd/.lnd directory.

### How to use ?
You can use the sample docker-compose (v3) file below:

```yml
version: '3'
services:
  docker-lnd:
    container_name: lnd
    restart: unless-stopped
    stop_signal: SIGKILL
    build: build/
    ports:
      - "0.0.0.0:9735:9735"                               # Daemon Listener
      - "0.0.0.0:9911:9911"                               # Watchtower
      - "0.0.0.0:10009:10009"                             # RPC Server
      - "0.0.0.0:8080:8080"                               # gRPC Server
    volumes:
      - lnd-data:/data
    command:
      - --bitcoin.active                                  # Connect to bitcoin network
      - --bitcoin.mainnet                                 # On mainnet
      - --debuglevel=debug                                # Debug level
      - --bitcoin.node=bitcoind                           # Bitcoind backend
      - --maxpendingchannels=10                           # Max Pending channels
      - --bitcoind.rpcuser=api                            # Your bitcoind RPC user
      - --bitcoind.rpcpass=api                            # Your bitcoind RPC password
      - --bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332   # Your bitcoind ZMQ connections for raw blocks
      - --bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333      # Your bitcoind ZMQ connections for raw transactions
      - --alias=testnode                                  # Alias of your Node
      - --externalip=2.3.4.5                              # External IPV4 address
      - --color=#ffdc00                                   # Lightning node color
volumes:
  lnd-data:
```

## Interracting with your container
### Starting lnd daemon
In order to start lnd you will need to have a local bitcoind node running in either mainnet, testnet or regtest mode.

Wait until bitcoind has synchronized with the testnet network **before** launching lnd.

Make sure that you do not have walletbroadcast=0 in your ~/.bitcoin/bitcoin.conf, or you may run into trouble. Notice that currently pruned nodes are not supported and may result in lightningd being unable to synchronize with the blockchain.

You can start lightningd with the following command:
```bash
docker-compose up -d
```

### How to use
#### Example: get all the commands availables in lncli
```bash
docker-compose exec docker-lnd lncli -h
```
#### Example: get your lightning node infos
```bash
docker-compose exec docker-lnd lncli getinfo
```
#### Example: unlock your wall
```bash
docker-compose exec docker-lnd lncli unlock
```

