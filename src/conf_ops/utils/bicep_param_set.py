
#   -------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   -------------------------------------------------------------

import os

def bicep_param_set(file_path, key, value):

    print(f'Setting parameter {key} to {value[:50]}{"..." if len(value) > 50 else ""}')
    with open(file_path, "r") as file:
        content = file.read().split(os.linesep)

    param_found = False

    for i, line in enumerate(content):
        if line.startswith(f"param {key}="):
            statement_end = i
            for start, end in (("[", "]"), ("{", "}")):
                if start in line:
                    for j in range(i, len(content)):
                        if end in content[j]:
                            statement_end = j
                            break
            del content[i:statement_end]
            content[i] = f"param {key}={value}"
            param_found = True
            break

    if not param_found:
        content.append(f"param {key}={value}")

    with open(file_path, "w") as file:
        file.write(os.linesep.join(content))