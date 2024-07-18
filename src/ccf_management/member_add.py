
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import json

from argparse import Namespace
from .args_parse import args_parse, check_args
from .proposal_submit import proposal_submit

def member_add(args: Namespace) -> None:
    check_args(args,
        "participant_name",
        "certs_dir",
    )

    setattr(args, "proposal", json.dumps({
        "actions": [
            {
                "name": "set_member",
                "args": {
                    "cert": open(f"{args.certs_dir}/{args.participant_name}_cert.pem").read(),
                    "encryption_pub_key": open(f"{args.certs_dir}/{args.participant_name}_enc_pubk.pem").read()
                }
            }
        ]
    }))

    return proposal_submit(args)

if __name__ == "__main__":
    print(member_add(args_parse()))