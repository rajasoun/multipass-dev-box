#!/usr/bin/env ./test/libs/bats/bin/bats

load '../libs/bats-support/load'
load '../libs/bats-assert/load'
load '../helpers'

ansible_profile_script="./src/lib/ansible.bash"
os_profile_script="./src/lib/os.bash"
checks_profile_script="./src/lib/checks.bash"

multipass_checks_profile_script="./src/multipass/checks.bash"
api_profile_script="./src/multipass/vm_api.bash"

instance_env="instance.env"

function init_api_test() {
  # shellcheck disable=SC1090
  source "$api_profile_script"
  # shellcheck disable=SC1090
  source "$checks_profile_script"
  # shellcheck disable=SC1090
  source "$multipass_checks_profile_script"
  # shellcheck disable=SC1090
  source "$ansible_profile_script"
  # shellcheck disable=SC1090
  source "$os_profile_script"

  # shellcheck disable=SC1090
  source ${instance_env}

### Env Properties Can be Overriden as below
  unset VM_NAME
  assert_empty "${VM_NAME}"
  VM_NAME="API-TEST-VM"
  unset SSH_KEY_PATH
  assert_empty "${SSH_KEY_PATH}"
  SSH_KEY_PATH="$TEST_DATA/keys/multipass"

  unset CONFIG_BASE_PATH
  assert_empty "${CONFIG_BASE_PATH}"
  CONFIG_BASE_PATH="$TEST_DATA/config"
  run create_directory_if_not_exists "$CONFIG_BASE_PATH"
  assert_success
}