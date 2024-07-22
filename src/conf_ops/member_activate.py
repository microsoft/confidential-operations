
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

from argparse import Namespace
from .args_parse import args_parse, check_args
from .participant_get_id import participant_get_id
from .utils.call_endpoint import call_endpoint

def member_activate(args: Namespace) -> None:
    check_args(args,
        "node_address",
        "participant_name",
        "certs_dir",
    )

    proposer = args.proposer_name
    setattr(args, "proposer_name", "")

    state_digest = call_endpoint(args,
        endpoint=f"gov/members/state-digests/{participant_get_id(args)}:update?api-version=2023-06-01-preview",
        method="POST",
        message_type="state_digest",
        payload=b"",
    )

    call_endpoint(args,
        endpoint=f"gov/members/state-digests/{participant_get_id(args)}:ack?api-version=2023-06-01-preview",
        method="POST",
        message_type="ack",
        payload=state_digest,
    )

    setattr(args, "proposer_name", proposer)

if __name__ == "__main__":
    args = args_parse()
    member_activate(args)
    print(f"Member {participant_get_id(args)} activated successfully.")