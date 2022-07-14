#!/bin/bash

if [[ -z "$HOME" ]]; then
    echo "HOME undefined." 1>&2
    exit 1
fi

# Initialize.
echo "Initializing Singularity..."
singularity init
ls $HOME/.singularity

echo "Setting up config for deal prep only."
cp $HOME/.singularity/default.toml $HOME/.singularity/default.toml.orig
cp ./deal-prep-only.toml $HOME/.singularity/default.toml

# Run as daemon.
echo "Starting singularity daemon..."
nohup singularity daemon >> singularity-daemon.log 1>&2
echo "Started singularity daemon."

# Generate test data
echo "Preparing test data..."
export DATASET_PATH=/tmp/source
export OUT_DIR=/tmp/car
export DATASET_NAME="test0000"
mkdir -p $DATASET_PATH
mkdir -p $OUT_DIR
cp -r /root/singularity $DATASET_PATH

# Run test
echo "Running test..."
export SINGULARITY_CMD="singularity prep create $DATASET_NAME $DATASET_PATH $OUT_DIR"
echo "executing command: $SINGULARITY_CMD"
time $SINGULARITY_CMD

# Verify test result
echo "Verifying test output..."
ls $OUT_DIR
# TODO additional test verification. 

# TODO additional tests.

# TODO post test results somewhere.

echo "End of test script."
