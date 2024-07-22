# Confidential Operations

Confidential Operations is a suite of utilities for managing a CCF service, it has the
following targets:

  - `conf_ops.participant_create`
  - `conf_ops.participant_get_id`
  - `conf_ops.service_await`
  - `conf_ops.service_create`
  - `conf_ops.service_get_cert`
  - `conf_ops.service_open`
  - `conf_ops.service_remove`
  - `conf_ops.member_activate`
  - `conf_ops.constitution_get`
  - `conf_ops.constitution_update`
  - `conf_ops.proposal_submit`
  - `conf_ops.js_app_set`

## Getting Started

### Install the `conf_ops` package

```
latest=$(gh release list -R microsoft/confidential-operations -L 1 --json tagName --jq '.[0].tagName')
gh release download $latest -R microsoft/confidential-operations
pip install conf_ops*.tar.gz
rm conf_ops*.tar.gz
```

## Starting a Minimal CCF Service

We interact with CCF via identities such as members or users.
Each identity comprises of a certificate and a key pair, which will be stored in
a directory which the user manages.

Most targets take a parameter `--certs-dir` which is the path to this directory,
as with all parameters in conf_ops, you can also specify via an env variable:
```
export CERTS_DIR=./certs
```

---

To start a minimal CCF service, first create an initial member:
```
export PROPOSER_NAME=member0
python -m conf_ops.participant_create --participant-name member0
```

---

Next you can choose where to deploy the initial node:

### Locally

This is useful for testing
```
python -m conf_ops.service_create
```

### ACI
```
python -m conf_ops.service_deploy --deployment-name <my-dep>
```

---

Once the service is deployed you will see the address of the node in the logs, export this node address:

```
export NODE_ADDRESS=<my_address>
```

The service starts in an initialised state until the initial member has been activated:
```
python -m conf_ops.member_activate --participant-name member0
```

Then the service is ready to be opened:
```
python -m conf_ops.service_open
```

## Updating the Constitution

To add to the initial constitution, run:

```
python -m conf_ops.constitution_update \
  --constitution-fragment <path to fragment>
  --constitution-fragment <path to other fragment>
```

## Deploying a JS Application

To set the JS app, run:

```
python -m conf_ops.js_app_set --js-app-bundle <path to bundle>
```

## Submitting Custom Proposals

To submit your own proposal:

```
python -m conf_ops.proposal_submit --proposal <path to proposal>
```

## Voting on Proposals

Coming soon

## Adding Nodes

Coming soon

## Adding Members

Firstly create a new participant identity:

```
python -m conf_ops.participant_create --participant-name member1
```

Then submit a proposal to add the new member:

```
python -m conf_ops.member_add --participant-name member1
```

Then activate the new member in the same way as the initial member:

```
python -m conf_ops.member_activate --participant-name member1
```

## Adding Users

Coming soon

## Contributing

To take administrator actions such as adding users as contributors, please refer to [engineering hub](https://eng.ms/docs/initiatives/open-source-at-microsoft/github/opensource/repos/jit)

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft
trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.