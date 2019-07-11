# Lightning Network Daemon (lnd) docker container

Star this project on Docker Hub :star2: https://hub.docker.com/r/fedorage/lnd

## Getting started
This project is a personnal initiative base on the source code of in https://github.com/lightningnetwork/lnd .

This docker container is a tiny **alpine/adm64** compatible container, automatically built from Official lnd team releases on https://github.com/lightningnetwork/lnd/releases.

## What is Lightning Network ?
The Lightning Network Daemon (`lnd`) - is a complete implementation of a [Lightning Network](https://lightning.network) node.  `lnd` has several pluggable back-end chain services including [`btcd`](https://github.com/btcsuite/btcd) (a full-node), [`bitcoind`](https://github.com/bitcoin/bitcoin), and [`neutrino`](https://github.com/lightninglabs/neutrino) (a new experimental light client). The project's codebase uses the
[btcsuite](https://github.com/btcsuite/) set of Bitcoin libraries, and also exports a large set of isolated re-usable Lightning Network related libraries within it. 


### Configuration File
No configuration file is needed as you can add parameters to the "command" docker parameter. To see all options available, see reference file https://github.com/lightningnetwork/lnd/blob/master/sample-lnd.conf

If you wish to use a configuration file, change volume configuration to map your existing configuration file path.

### Persistance
A persistant volume is created on the fly, linked to /home/lnd/.lnd directory.

### How to use ?
You can use the sample docker-compose (v3) file below for **bitcoind** backend:

```yml
version: '3'
services:
  lnd:
    image: fedorage/lnd:latest
    container_name: lnd
    restart: unless-stopped
    ports:
      - "0.0.0.0:9735:9735"                               # Daemon Listener
      - "0.0.0.0:9911:9911"                               # Watchtower
      - "0.0.0.0:10009:10009"                             # RPC Server
      - "0.0.0.0:8080:8080"                               # gRPC Server
    volumes:
      - lnd-data:/data
    command:
      - lnd
      - --bitcoin.active                                  # Connect to bitcoin network
      - --bitcoin.mainnet                                 # On mainnet
      - --debuglevel=debug                                # Debug level
      - --bitcoin.node=bitcoind                           # Bitcoind backend
      - --maxpendingchannels=10                           # Max Pending channels
      - --bitcoind.rpchost=127.0.0.1                      # Bitcoind IP address
      - --bitcoind.rpcuser=api                            # Bitcoind RPC user
      - --bitcoind.rpcpass=api                            # Bitcoind RPC password
      - --bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332   # Bitcoind ZMQ connections for raw blocks
      - --bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333      # Bitcoind ZMQ connections for raw transactions
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
docker-compose exec lnd lncli -h
```
#### Example: get your lightning node infos
```bash
docker-compose exec lnd lncli getinfo
```
#### Example: unlock your wall
```bash
docker-compose exec lnd lncli unlock
```

