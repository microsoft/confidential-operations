
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import os
import subprocess

from argparse import Namespace
from .args_parse import args_parse, check_args

def participant_get_id(args: Namespace) -> str:
    check_args(args,
        "participant_name",
        "certs_dir",
    )

    response = subprocess.run([
        "openssl", "x509",
        "-in", os.path.join(args.certs_dir, f"{args.participant_name}_cert.pem"),
        "-noout", "-fingerprint", "-sha256"
    ], check=True, stdout=subprocess.PIPE)

    participant_id = response.stdout.decode().split("=")[1].strip().replace(":", "").lower()
    return participant_id

if __name__ == "__main__":
    print(participant_get_id(args_parse()))