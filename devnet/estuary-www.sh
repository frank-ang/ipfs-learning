#!/bin/bash
. ./devnet.env
export ESTUARY_WWW_BIN_PATH=$HOME/lab/estuary-www

cd $ESTUARY_WWW_BIN_PATH
ESTUARY_API=http://localhost:3004 npm run dev