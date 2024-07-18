
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import os
import subprocess

from argparse import Namespace
from .args_parse import args_parse, check_args
from .service_await import service_await
from .service_get_cert import service_get_cert

def service_create(args: Namespace) -> None:
    check_args(args,
        "certs_dir",
    )

    response = subprocess.run([
        "docker", "compose",
        "-f", os.path.join(__file__, "..", "docker", "docker-compose.yml"),
        "run", "--build", "-d", "virtual-ccf",
    ], env={
        "CCHOST_CONFIG": os.path.abspath(os.path.join(__file__, "..", "ccf_config", "cchost_config.json.template")),
        "CERTS_DIR": args.certs_dir,
    }, check=True, stdout=subprocess.PIPE)

    node_container_id = response.stdout.decode("utf-8").strip("\n").split("\n")[-1]
    setattr(args, "node_container_id", node_container_id)

    service_await(args)
    print("Service running")

    service_cert_path = os.path.join(args.certs_dir, "service_cert.pem")
    with open(service_cert_path, "w") as f:
        f.write(service_get_cert(args))
    print(f"Service certificate written to {service_cert_path}")

if __name__ == "__main__":
    service_create(args_parse())