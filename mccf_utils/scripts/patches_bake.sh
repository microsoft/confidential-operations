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

    # Get list of changed files (staged and unstaged), only .bicep files
    CHANGED_FILES=()
    while IFS= read -r -d '' FILE; do
        if [[ "$FILE" == *.bicep ]]; then
            CHANGED_FILES+=("$FILE")
        fi
    done < <(git diff --name-only -z HEAD)

    # For each changed .bicep file, create a patch file
    for FILE in "${CHANGED_FILES[@]}"
    do
        # Create the patch file name
        PATCH_FILE="$PATCHES_DIR/$(basename "$FILE").patch"
        # Generate the diff and save to patch file
        git diff HEAD -- "$FILE" > $PATCH_FILE
        echo "Created $(basename "$FILE").patch"
    done
)