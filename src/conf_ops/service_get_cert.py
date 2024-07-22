
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import json
import os
import subprocess

from argparse import Namespace

from .args_parse import args_parse, check_args

def service_get_cert(args: Namespace) -> str:
    check_args(args,
        "node_address",
        "certs_dir",
    )

    os.makedirs(args.certs_dir, exist_ok=True)

    response = subprocess.run([
        "curl", "-k", f"https://{args.node_address}/node/network",
    ], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    return json.loads(response.stdout)["service_certificate"]

if __name__ == "__main__":
    print(service_get_cert(args_parse()))