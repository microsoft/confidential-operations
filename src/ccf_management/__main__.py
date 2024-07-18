
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import os


def main():
    with open(os.path.join(os.path.dirname(__file__), "README.md"), "r") as f:
        print(f.read().split("## Contributing")[0])

if __name__ == "__main__":
    main()