
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import json

from argparse import Namespace
from .args_parse import args_parse
from .proposal_submit import proposal_submit

def js_app_set(args: Namespace) -> None:

    setattr(args, "proposal", json.dumps({
        "actions": [
            {
                "name": "set_js_app",
                "args": {
                    "bundle": json.loads(args.js_app_bundle),
                    "disable_bytecode_cache": False,
                }
            }
        ]
    }))

    return proposal_submit(args)

if __name__ == "__main__":
    print(js_app_set(args_parse()))
