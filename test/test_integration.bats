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
}

teardown() {
  echo "teardown"
  rm -fr $TEST_DATA #Remove Directory created during Test
} 

@test ".check_required_workspace_env_vars fails - when environment variables not set for any of the variables in workspace.env" {
  source ${checks_profile_script}
  source ${workspace_env}
  unset CLOUD_INIT_TEMPLATE
  assert_empty "${CLOUD_INIT_TEMPLATE}"
  run check_required_workspace_env_vars
  assert_failure
  assert_output --partial "CLOUD_INIT_TEMPLATE"
}

@test ".check_required_instance_env_vars - when environment variables not set for any of the variables in instance.env" {
  source ${checks_profile_script}
  source ${instance_env}
  unset VM_NAME
  assert_empty "${VM_NAME}"
  run check_required_instance_env_vars
  assert_failure
  assert_output --partial "VM_NAME"
}

@test ".generate_ssh_key - Validate ssk-keygen Available and Generate key" {
    source ${os_profile_script}
    run os_command_is_installed "ssh-keygen"
    assert_success

    source ${checks_profile_script}
    source ${workspace_env}
    run check_required_workspace_env_vars
    assert_success 

    # assert_success  
    # unset SSH_KEY_PATH
    # assert_empty "${SSH_KEY_PATH}"
    # SSH_KEY_PATH="$WORKSPACE/$TEST_DATA/keys/multipass"
    # source ${actions_profile_script}
    # run create_directory_if_not_exists $SSH_KEY_PATH
    # assert_success   
    # run generate_ssh_key
    # assert_success
}