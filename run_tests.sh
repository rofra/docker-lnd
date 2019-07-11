#!/usr/bin/env sh
set -e

# Launch lnd daemon
lnd --bitcoin.active --bitcoin.mainnet --debuglevel=debug --bitcoin.node=bitcoind  --bitcoind.rpcuser=api --bitcoind.rpcpass=api &
sleep 10

lncli --version
lnd -V
