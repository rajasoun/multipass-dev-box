#!/usr/bin/env ./test/libs/bats/bin/bats
load '../libs/bats-support/load'
load '../libs/bats-assert/load'
load '../helpers'


multipass_actions_profile_script="./src/multipass/actions.bash"
multipass_checks_profile_script="./src/multipass/checks.bash"


cloud_init_profile_script="./src/lib/cloud_init.bash"
checks_profile_script="./src/lib/checks.bash"
os_profile_script="./src/lib/os.bash"
ssh_profile_script="./src/lib/ssh.bash"
ansible_profile_script="./src/lib/ansible.bash"

workspace_env="workspace.env"
instance_env="instance.env"

function init_integration_test() {
    # shellcheck disable=SC1090
    source ${instance_env}
    # shellcheck disable=SC1090
    source ${workspace_env}
    # shellcheck disable=SC1090
    source ${multipass_actions_profile_script}
    # shellcheck disable=SC1090
    source ${multipass_checks_profile_script}
    # shellcheck disable=SC1090
    source ${checks_profile_script}
    # shellcheck disable=SC1090
    source ${cloud_init_profile_script}
    # shellcheck disable=SC1090
    source ${os_profile_script}
    # shellcheck disable=SC1090
    source ${ssh_profile_script}
    # shellcheck disable=SC1090
    source ${ansible_profile_script}

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
    VM_NAME="Integration-TEST-VM"

    unset DOMAIN
    assert_empty "${DOMAIN}"
    DOMAIN="test_bizapps.cisco.com_test"
}

