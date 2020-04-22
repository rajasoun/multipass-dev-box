#!/usr/bin/env bash

## To get all functions : bash -c "source src/load.bash && declare -F"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=dev-tools/src/cli/multipass.bash
source "$SCRIPT_DIR/cli/multipass.bash"
# shellcheck source=dev-tools/src/cli/_docker.bash
source "$SCRIPT_DIR/cli/_docker.bash"
# shellcheck source=dev-tools/src/cli/dev_tools_sandbox.bash
source "$SCRIPT_DIR/cli/dev_tools_sandbox.bash"
# shellcheck source=dev-tools/src/cli/git.bash
source "$SCRIPT_DIR/cli/git.bash"
# shellcheck source=dev-tools/src/lib/os.bash
source "$SCRIPT_DIR/lib/os.bash"
# shellcheck source=dev-tools/src/lib/etc_hosts.bash
source "$SCRIPT_DIR/lib/etc_hosts.bash"
# shellcheck source=dev-tools/src/lib/web.bash
source "$SCRIPT_DIR/lib/web.bash"
# shellcheck source=dev-tools/src/cli/aws_env.bash
source "$SCRIPT_DIR/cli/aws_env.bash"