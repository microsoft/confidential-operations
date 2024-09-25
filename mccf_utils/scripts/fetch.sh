#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/../env"

if [ ! -d "acc_ledger" ]; then

    if [ -z "$ADO_USER" ] || [ -z "$ADO_PAT" ]; then
        read -p "Press enter to get credentials, select 'Clone' and 'Generate Git Credentials'"
        $SCRIPT_DIR/open_url.sh "https://msazure.visualstudio.com/One/_git/ACC%20Ledger"

        variables=(
            "ADO_USER:Please enter your Azure DevOps User Name: "
            "ADO_PAT:Please enter your Azure DevOps Personal Access Token: "
        )
        for var in "${variables[@]}"; do
            var_name="${var%%:*}"
            prompt="${var#*:}"
            if [ -z "${!var_name}" ]; then
                read -p "$prompt" var_value
                if grep -q "export $var_name=" $SCRIPT_DIR/../env; then
                    sed -i "s|export $var_name=.*|export $var_name=$var_value|" $SCRIPT_DIR/../env
                else
                    echo "export $var_name=$var_value" >> $SCRIPT_DIR/../env
                fi
            fi
        done
    fi

    git clone https://$ADO_USER:$ADO_PAT@msazure.visualstudio.com/DefaultCollection/One/_git/ACC%20Ledger acc_ledger
fi

