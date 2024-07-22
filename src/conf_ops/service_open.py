
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import json

from argparse import Namespace
from .args_parse import args_parse
from .service_get_cert import service_get_cert
from .proposal_submit import proposal_submit

def service_open(args: Namespace) -> None:

    setattr(args, "proposal", json.dumps({
        "actions": [
            {
                "name": "transition_service_to_open",
                "args": {
                    "next_service_identity": service_get_cert(args)
                }
            }
        ]
    }))

    return proposal_submit(args)

if __name__ == "__main__":
    print(service_open(args_parse()))