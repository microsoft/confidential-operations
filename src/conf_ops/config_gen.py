
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import json
import os
from argparse import Namespace
from .args_parse import args_parse

def config_gen(args: Namespace) -> str:

    template_path = os.path.abspath(os.path.join(__file__, "..", "ccf_config", "cchost_config.json.template"))
    with open(template_path, "r") as f:
        config = json.load(f)

    if args.ccf_platform == "snp":
        config["enclave"] = {
            "file": "/usr/lib/ccf/libjs_generic.snp.so",
            "type": "Release",
            "platform": "SNP"
        }

    return json.dumps(config)

if __name__ == "__main__":
    print(config_gen(args_parse()))
