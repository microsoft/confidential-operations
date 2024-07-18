
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import json

from argparse import Namespace
from .args_parse import args_parse, check_args
from .constitution_get import constitution_get
from .proposal_submit import proposal_submit

def constitution_update(args: Namespace) -> None:
    check_args(args,
        "constitution_fragment",
    )

    setattr(args, "proposal", json.dumps({
        "actions": [
            {
                "name": "set_constitution",
                "args": {
                    "constitution": constitution_get(args).decode() + "".join(args.constitution_fragment),
                }
            }
        ]
    }))

    return proposal_submit(args)



if __name__ == "__main__":
    print(constitution_update(args_parse()))
