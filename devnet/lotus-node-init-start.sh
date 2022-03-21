#!/bin/bash
# Sets up lotus devnet and starts the node.
# Prereq: build lotus.

. ./devnet.env

echo "#### Setting up Lotus devnet."

# Archive previous data
if [ -e $LOTUS_PATH ] ; then
    mv $LOTUS_PATH "$LOTUS_PATH."`date +%Y.%m.%d-%H:%M:%S`
fi
if [ -e $GENESIS_SECTORS_PATH ] ; then
    mv $GENESIS_SECTORS_PATH "$GENESIS_SECTORS_PATH."`date +%Y.%m.%d-%H:%M:%S`
fi
rm -f $LOTUS_BIN_PATH/devgen.car $LOTUS_BIN_PATH/localnet.json

# init node.
echo "\n#### Fetch proving parameters for 2KB sector size...\n"
$LOTUS_BIN_PATH/lotus fetch-params 2048
echo "\n#### Pre-seal some sectors for the genesis block...\n"
$LOTUS_BIN_PATH/lotus-seed pre-seal --sector-size 2KiB --num-sectors 2
echo "\n#### Create new genesis block template...\n"
$LOTUS_BIN_PATH/lotus-seed genesis new $LOTUS_BIN_PATH/localnet.json
echo "\n#### Add genesis miner and Fund the default account with some FIL...\n"
$LOTUS_BIN_PATH/lotus-seed genesis add-miner $LOTUS_BIN_PATH/localnet.json $GENESIS_SECTORS_PATH/pre-seal-t01000.json

# start the first node.
echo "\n#### Starting first node\n"
$LOTUS_BIN_PATH/lotus daemon --lotus-make-genesis=$LOTUS_BIN_PATH/devgen.car --genesis-template=$LOTUS_BIN_PATH/localnet.json --bootstrap=false
