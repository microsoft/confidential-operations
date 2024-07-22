
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import os
import subprocess

from argparse import Namespace
from .args_parse import args_parse

def service_remove(args: Namespace) -> None:
    subprocess.run([
        "docker", "compose",
        "-f", os.path.join(__file__, "..", "docker", "docker-compose.yml"),
        "kill", "virtual-ccf",
    ], check=True)

if __name__ == "__main__":
    service_remove(args_parse())