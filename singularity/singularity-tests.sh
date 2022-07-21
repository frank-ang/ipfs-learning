#!/bin/bash

if [[ -z "$HOME" ]]; then
    echo "HOME undefined." 1>&2
    exit 1
fi

# increase limits
ulimit -n 100000

# Initialize.
echo "Initializing Singularity..."
singularity init
ls $HOME/.singularity
echo "Setting up config for deal prep only."
cp $HOME/.singularity/default.toml $HOME/.singularity/default.toml.orig
cp ./deal-prep-only.toml $HOME/.singularity/default.toml
# Start daemon.
echo "Starting singularity daemon..."
nohup singularity daemon 2>&1 &
echo "Started singularity daemon."

# Wait for singularity daemon startup.
sleep 8
nc -vz localhost 7001
singularity prep list

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
echo "listing of $OUT_DIR: "`ls -lh $OUT_DIR`
echo "size of $OUT_DIR: "`du -sh $OUT_DIR`
echo "count of regular files in $OUT_DIR: "`find -type f $OUT_DIR | wc -l`

# TODO additional test verification.
# TODO verify database query
# TODO verify CAR structure.
# TODO un-CAR and diff.

# TODO additional tests.

# TODO post test results somewhere.

echo "End of test script."
