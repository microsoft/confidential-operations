
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import os
import subprocess

from argparse import Namespace
import tempfile

from .utils.bicep_param_set import bicep_param_set
from .config_gen import config_gen
from .args_parse import args_parse, check_args

def service_deploy(args: Namespace) -> str:
    check_args(args,
        "certs_dir",
        "registry",
        "tag",
        "location",
        "managed_id_name",
    )

    with tempfile.NamedTemporaryFile() as f:
        setattr(args, "ccf_platform", "snp")
        f.write(config_gen(args).encode("utf-8"))
        f.flush()

        response = subprocess.run(" ".join([
            "docker", "compose",
            "-f", os.path.join(__file__, "..", "docker", "docker-compose.yml"),
            "run", "--build", "-d", "snp-ccf", "/bin/bash", "-c",
            "\"cp -r /mnt/certs /app/certs && cp /mnt/cchost_config.json /app/cchost_config.json && sleep infinity\"",
        ]), env={
            "CCHOST_CONFIG": f.name,
            "CERTS_DIR": args.certs_dir,
        }, check=True, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        node_container_id = response.stdout.decode("utf-8").strip("\n").split("\n")[-1]

        # Commit the mounts to the container image
        image_tag = f"{args.registry}/ccf/snp:{args.tag}"
        subprocess.run(["docker", "commit", node_container_id, image_tag], check=True)
        subprocess.run(["docker", "kill", node_container_id], check=True, stdout=subprocess.PIPE)

    # Push the image
    subprocess.run(["az", "acr", "login", "-n", args.registry], check=True)
    subprocess.run(["docker", "push", image_tag], check=True)

    # Set the deployment parameters
    param_file_path = os.path.abspath(os.path.join(__file__, "..", "bicep", "ccf.bicepparam"))
    bicep_param_set(param_file_path, "registry", f"'{args.registry}'")
    bicep_param_set(param_file_path, "tag", f"'{args.tag}'")
    bicep_param_set(param_file_path, "location", f"'{args.location}'")
    bicep_param_set(param_file_path, "managedIDName", f"'{args.managed_id_name}'")

    res = subprocess.run([
        "az", "deployment", "group", "create",
	    "--name", args.deployment_name,
	    "--resource-group", args.resource_group,
	    "--template-file", os.path.abspath(os.path.join(__file__, "..", "bicep/ccf.bicep")),
	    "--parameters", param_file_path,
        "--query", "properties.outputs.nodeAddress.value",
    ], check=True, stdout=subprocess.PIPE)

    return res.stdout.decode("utf-8").replace("\n", "").strip('"')

if __name__ == "__main__":
    node_url = service_deploy(args_parse())
    print("Service deployed, run:")
    print(f"export NODE_ADDRESS={node_url}:8000")