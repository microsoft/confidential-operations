#!/bin/bash

SCRIPT_DIR=$(dirname "$0")

if grep -q "\$PREFIX" "$SCRIPT_DIR/../bicep/services.bicepparam"; then
    read -p "What would you like to call your resource group? (This will also be a prefix for resources): " PREFIX
    sed -i "s/\$PREFIX/$PREFIX/g" "$SCRIPT_DIR/../bicep/services.bicepparam"
    echo "Prefix set in bicepparam, feel free to manually make further changes"
fi