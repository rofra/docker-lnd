#!/usr/bin/env sh
set -e
# Launch lnd daemon
lnd --nolisten --bitcoin.active --bitcoin.mainnet --debuglevel=debug --bitcoin.node=bitcoind  --bitcoind.rpcuser=api --bitcoind.rpcpass=api --bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332 --bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333 &
sleep 10

# Test client and daemon
lncli --version
lnd -V
