#!/bin/bash
. ./devnet.env
export ESTUARY_BIN_PATH=$HOME/lab/estuary
export FULLNODE_API_INFO=http://localhost:1234
export ESTUARY_DATA_DIR=/tmp/estuary
export ESTUARY_AUTH_TOKEN_FILE="$ESTUARY_BIN_PATH/estuary_auth_token.gitignore"

help () {
    echo "Reset or start local devnet Estuary. Requires Estuary to be built."
    echo "Usage: $0 [ --reset | --setup | --start ]"    
}

reset_estuary () {
    echo "#### Resetting Estuary..."
    rm -f $ESTUARY_BIN_PATH/estuary-shuttle.db
    rm -f $ESTUARY_BIN_PATH/estuary.db
    rm -rf $ESTUARY_DATA_DIR/*
    rm -rf $ESTUARY_BIN_PATH/leveldb/*
    rm -rf $ESTUARY_BIN_PATH/wallet/*
    rm -rf $ESTUARY_BIN_PATH/blocks/*
    rm -rf $ESTUARY_BIN_PATH/cidlistsdir/*
    rm -rf $ESTUARY_BIN_PATH/staging/*
}

setup_estuary () {
    echo "#### Setting up Estuary..."
    cd $ESTUARY_BIN_PATH
    setup_output=$($ESTUARY_BIN_PATH/estuary setup)
    echo "setup output: $setup_output"
    auth_token=$(sed -n 's/.*\(EST.*ARY\)/\1/p' <<< $setup_output)
    echo "auth token: $auth_token"
    echo "$auth_token" > $ESTUARY_AUTH_TOKEN_FILE
}

start_estuary () {
    echo "#### Starting Estuary... "
    cd $ESTUARY_BIN_PATH
    CMD="$ESTUARY_BIN_PATH/estuary --datadir=$ESTUARY_DATA_DIR --repo=$LOTUS_PATH sqlite=$ESTUARY_BIN_PATH/estuary.db --logging"
    echo "executing: $CMD"
    $($CMD)
}

if [[ $# -lt 1 ]]; then help && exit 1; fi

while [ -n "$1" ]
do
case "$1" in
--start) start_estuary ;;
--setup) setup_estuary ;;
--reset) reset_estuary ;;
*) echo "$1 is not an option" && help && exit 1;;
esac
shift
done


