
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

from argparse import Namespace
from .args_parse import args_parse, check_args
from .utils.call_endpoint import call_endpoint

def proposal_submit(args: Namespace) -> None:
    check_args(args,
        "node_address",
        "participant_name",
        "certs_dir",
        "proposal",
    )

    return call_endpoint(args,
        endpoint="gov/members/proposals:create?api-version=2023-06-01-preview",
        method="POST",
        message_type="proposal",
        payload=args.proposal.encode(),
    )

if __name__ == "__main__":
    print(proposal_submit(args_parse()))