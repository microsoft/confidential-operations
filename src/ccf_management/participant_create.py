
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import os
import subprocess

from argparse import Namespace
from .args_parse import args_parse, check_args

def participant_create(args: Namespace) -> None:
    check_args(args,
        "participant_name",
        "certs_dir",
    )

    os.makedirs(args.certs_dir, exist_ok=True)

    subprocess.run([
        "docker", "compose",
        "-f", os.path.join(__file__, "..", "docker", "docker-compose.yml"),
        "run", "keygenerator",
    ], env={
        "NAME": args.participant_name,
        "CERTS_DIR": args.certs_dir,
    }, check=True)

if __name__ == "__main__":
    participant_create(args_parse())