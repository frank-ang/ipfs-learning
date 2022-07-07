#!/bin/bash
export LOTUS_PATH=$HOME/.lotusLite
export LOTUS_BIN_PATH=$HOME/lab/lotus
FULLNODE_API_INFO=wss://api.chain.love $LOTUS_BIN_PATH/lotus daemon --lite

