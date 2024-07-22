
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import os
import subprocess

from datetime import datetime
from argparse import Namespace
from ccf.cose import create_cose_sign1
from ..args_parse import check_args

def call_endpoint(
    args: Namespace,
    endpoint: str,
    method: str = "GET",
    message_type: str = None,
    payload: bytes = b"",
) -> bytes:
    check_args(args,
        "node_address",
        "participant_name",
        "certs_dir",
    )

    proposer_name = args.proposer_name or args.participant_name

    key_priv_pem_path = os.path.join(args.certs_dir, f"{proposer_name}_privk.pem")
    with open(key_priv_pem_path, "r") as f:
        key_priv_pem = f.read()

    cert_pem_path = os.path.join(args.certs_dir, f"{proposer_name}_cert.pem")
    with open(cert_pem_path, "r") as f:
        cert_pem = f.read()

    is_cose = message_type is not None

    run_cmd = [
        "curl", "-k",
        f"https://{args.node_address}/{endpoint}",
        "-X", method,
        "--cacert", os.path.join(args.certs_dir, "service_cert.pem"),
        "--key", key_priv_pem_path,
        "--cert", cert_pem_path,
    ]
    if is_cose:
        run_cmd.extend([
            "-H", "content-type: application/cose",
            "--data-binary", "@-",
        ])

    response = subprocess.run(run_cmd, input=create_cose_sign1(
        payload=payload,
        key_priv_pem=key_priv_pem,
        cert_pem=cert_pem,
        additional_protected_header={
            "ccf.gov.msg.type": message_type,
            "ccf.gov.msg.created_at": int(datetime.now().timestamp()),
        }
    ) if is_cose else None, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    return response.stdout