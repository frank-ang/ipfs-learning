#!/bin/bash

if [[ -z "$HOME" ]]; then
    echo "HOME undefined." 1>&2
    exit 1
fi

cd $HOME
# Initialize.
singularity init
ls $HOME/.singularity

cp $HOME/.singularity/default.toml $HOME/.singularity/default.toml.orig
cp ./deal-prep-only.toml $HOME/.singularity/default.toml

# Run as daemon.
echo "Running singularity daemon..."
singularity daemon
