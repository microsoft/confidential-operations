
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import subprocess

from argparse import Namespace
from .args_parse import args_parse, check_args

def service_await(args: Namespace) -> None:
    check_args(args,
        "node_container_id",
    )

    logs = ""
    while "Network TLS connections now accepted" not in logs:
        response = subprocess.run([
            "docker", "logs", args.node_container_id,
        ], check=True, stdout=subprocess.PIPE)
        logs = response.stdout.decode()

if __name__ == "__main__":
    service_await(args_parse())