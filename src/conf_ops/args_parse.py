
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import argparse
import os

def check_args(args: argparse.Namespace, *required: str) -> None:
    for arg in required:
        if not getattr(args, arg):
            raise ValueError(f'Missing required argument: --{arg.replace("_", "-")}')

def args_parse() -> argparse.Namespace:

    arg_parser = argparse.ArgumentParser()

    arg_parser.add_argument(
        "--certs-dir",
        type=os.path.abspath,
        help="Path to the directory where certificates are stored",
        default=os.getenv("CERTS_DIR"),
    )

    arg_parser.add_argument(
        "--resource-group",
        type=str,
        help="The container resource-group",
        default=os.getenv("RESOURCE_GROUP"),
    )

    arg_parser.add_argument(
        "--registry",
        type=str,
        help="The container registry",
        default=os.getenv("REGISTRY"),
    )

    arg_parser.add_argument(
        "--location",
        type=str,
        help="The container location",
        default=os.getenv("LOCATION"),
    )

    arg_parser.add_argument(
        "--tag",
        type=str,
        help="The container tag",
        default=os.getenv("TAG"),
    )

    arg_parser.add_argument(
        "--managed-id-name",
        type=str,
        help="The container managed id name",
        default=os.getenv("MANAGED_ID_NAME"),
    )

    arg_parser.add_argument(
        "--deployment-name",
        type=str,
        help="The container deployment name",
        default=os.getenv("DEPLOYMENT_NAME"),
    )

    arg_parser.add_argument(
        "--node-container-id",
        type=str,
        help="Container ID of the node",
        default=os.getenv("NODE_CONTAINER_ID"),
    )

    arg_parser.add_argument(
        "--ccf-platform",
        type=str,
        help="CCF Platform to use",
        default=os.getenv("CCF_PLATFORM", "virtual"),
    )

    arg_parser.add_argument(
        "--node-address",
        type=str,
        help="Address of the node",
        default=os.getenv("NODE_ADDRESS", "localhost:8000"),
    )

    arg_parser.add_argument(
        "--participant-name",
        type=str,
        help="Name of the participant",
        default=os.getenv("PARTICIPANT_NAME"),
    )

    arg_parser.add_argument(
        "--proposer-name",
        type=str,
        help="Name of the proposer",
        default=os.getenv("PROPOSER_NAME"),
    )

    arg_parser.add_argument(
        "--js-app-bundle",
        type=lambda path: open(path, "r").read(),
        help="The application bundle path",
        default=os.getenv("JS_APP_BUNDLE"),
    )

    arg_parser.add_argument(
        "--constitution-fragment",
        type=lambda path: open(path, "r").read(),
        help="The path to a constitution fragment",
        nargs="+",
        default=os.getenv("CONSTITUTION_FRAGEMENT"),
    )

    arg_parser.add_argument(
        "--proposal",
        type=lambda path: open(path, "r").read(),
        help="Proposal contents",
        default=os.getenv("PROPOSAL"),
    )

    return arg_parser.parse_args()