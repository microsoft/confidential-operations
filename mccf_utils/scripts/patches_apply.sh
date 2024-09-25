#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
PATCHES_DIR=$(realpath $SCRIPT_DIR/../patches)
ACC_LEDGER=$SCRIPT_DIR/../acc_ledger

# Check if the ACC_LEDGER directory exists
if [ ! -d "$ACC_LEDGER" ]; then
    echo "$ACC_LEDGER doesn't exist, run fetch.sh before proceeding"
    exit 1
fi

(
    cd "$ACC_LEDGER" || { echo "$ACC_LEDGER doesn't exist, run fetch.sh before proceeding"; exit 1; }

    for patch in "$PATCHES_DIR"/*.patch; do
        if [ -f "$patch" ]; then
            patch -p1 -N --reject-file=$patch.rej < "$patch"
        fi
    done
)
