
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

from argparse import Namespace
from .args_parse import args_parse
from .utils.call_endpoint import call_endpoint

def constitution_get(args: Namespace) -> str:

    return call_endpoint(args,
        endpoint=f"gov/service/constitution?api-version=2023-06-01-preview",
    )

if __name__ == "__main__":
    print(constitution_get(args_parse()))
