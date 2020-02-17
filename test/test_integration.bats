#!/usr/bin/env ./test/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

checks_profile_script="./src/multipass/checks.bash"
actions_profile_script="./src/multipass/actions.bash"
os_profile_script="./src/multipass/os.bash"

workspace_env="workspace.env"
instance_env="instance.env"

setup() {
    echo "SetUp"
    TEST_DATA="test/.test_data"
    # This block will run only for the first test in this file.
    # Usefull for setting up resources that should last for all tests.
    if [[ "$BATS_TEST_NUMBER" -eq 1 ]]; then
        echo "SetUp Once - For Entire Test Suite At the Begining"
        rm -fr $TEST_DATA #Remove Directory created during Test
    fi
}

teardown() {
  echo "teardown"
  # This block will run only for the last test case in this file.
  # Usefull for tearing down global resources.
  if [[ "${#BATS_TEST_NAMES[@]}" -eq "$BATS_TEST_NUMBER" ]]; then
    echo "Teardown Once for Entire Test Suite at the End"

  fi
  rm -fr $TEST_DATA #Remove Directory created during Test
}

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

@test ".check_required_workspace_env_vars fails - when environment variables not set for any of the variables in workspace.env" {
  common_steps
  unset CLOUD_INIT_TEMPLATE
  assert_empty "${CLOUD_INIT_TEMPLATE}"
  run check_required_workspace_env_vars
  assert_failure
  assert_output --partial "CLOUD_INIT_TEMPLATE"
}

@test ".check_required_instance_env_vars - when environment variables not set for any of the variables in instance.env" {
  common_steps
  unset VM_NAME
  assert_empty "${VM_NAME}"
  run check_required_instance_env_vars
  assert_failure
  assert_output --partial "VM_NAME"
}

@test ".sed - check sed works" {
    common_steps
    local SSH_KEY="id_rsa_${VM_NAME}"
    local SSH_CONNECT_FILE="$CONFIG_BASE_PATH/${VM_NAME}-temp-ssh-connect.sh"
    cp "$SSH_CONNECT_TEMPLATE" "$SSH_CONNECT_FILE"

    run file_replace_text "_private_key_" "keys/${SSH_KEY}" "$SSH_CONNECT_FILE"
    assert_success

    run file_contains_text "$SSH_KEY" "$SSH_CONNECT_FILE"
    assert_success
    rm -fr $SSH_CONNECT_FILE
}






