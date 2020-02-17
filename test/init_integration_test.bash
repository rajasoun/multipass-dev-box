#!/usr/bin/env ./test/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

checks_profile_script="./src/multipass/checks.bash"
actions_profile_script="./src/multipass/actions.bash"
os_profile_script="./src/multipass/os.bash"

workspace_env="workspace.env"
instance_env="instance.env"

function common_steps() {
    # shellcheck disable=SC1090
    source ${instance_env}
    # shellcheck disable=SC1090
    source ${workspace_env}
    # shellcheck disable=SC1090
    source ${os_profile_script}
    # shellcheck disable=SC1090
    source ${checks_profile_script}
    # shellcheck disable=SC1090
    source ${actions_profile_script}

    unset SSH_KEY_PATH
    assert_empty "${SSH_KEY_PATH}"
    SSH_KEY_PATH="$TEST_DATA/keys/multipass"
    run create_directory_if_not_exists "$SSH_KEY_PATH"
    assert_success

    unset CONFIG_BASE_PATH
    assert_empty "${CONFIG_BASE_PATH}"
    CONFIG_BASE_PATH="$TEST_DATA/config"
    run create_directory_if_not_exists "$CONFIG_BASE_PATH"
    assert_success

    unset VM_NAME
    assert_empty "${VM_NAME}"
    VM_NAME="TEST_VM"

    unset DOMAIN
    assert_empty "${DOMAIN}"
    DOMAIN="test_bizapps.cisco.com_test"
}