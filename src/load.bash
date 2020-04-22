#!/usr/bin/env bash

## To get all functions : bash -c "source src/load.bash && declare -F"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=src/lib/ansible.bash
source "$SCRIPT_DIR/lib/ansible.bash"
# shellcheck source=src/lib/cloud_init.bash
source "$SCRIPT_DIR/lib/cloud_init.bash"
# shellcheck source=src/lib/docker_wrapper.bash
source "$SCRIPT_DIR/lib/docker_wrapper.bash"
# shellcheck source=src/lib/menu.bash
source "$SCRIPT_DIR/lib/cli_builder.bash"
# shellcheck source=src/lib/os.bash
source "$SCRIPT_DIR/lib/os.bash"
# shellcheck source=src/lib/ssh.bash
source "$SCRIPT_DIR/lib/ssh.bash"

# shellcheck source=src/multipass/actions.bash
source "$SCRIPT_DIR/multipass/actions.bash"
# shellcheck source=src/multipass/checks.bash
source "$SCRIPT_DIR/multipass/checks.bash"
# shellcheck source=src/multipass/vm_api.bash
source "$SCRIPT_DIR/multipass/vm_api.bash"

