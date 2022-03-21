#!/bin/bash
# Initializes and Starts Miner.

. ./devnet.env

# Archive previous data
if [ -e $LOTUS_MINER_PATH ] ; then
    mv $LOTUS_MINER_PATH "$LOTUS_MINER_PATH."`date +%Y.%m.%d-%H:%M:%S`
fi

echo "\n#### Importing the genesis storage provider key...\n"

$LOTUS_BIN_PATH/lotus wallet import --as-default ~/.genesis-sectors/pre-seal-t01000.key

echo "\n#### Set up the genesis storage provider. This process can take a few minutes...\n"

$LOTUS_BIN_PATH/lotus-miner init --genesis-miner --actor=t01000 --sector-size=2KiB --pre-sealed-sectors=$GENESIS_SECTORS_PATH --pre-sealed-metadata=$GENESIS_SECTORS_PATH/pre-seal-t01000.json --nosync

echo "\n#### Starting the storage provider:"

$LOTUS_BIN_PATH/lotus-miner run --nosync
