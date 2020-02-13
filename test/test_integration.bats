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
    source ${os_profile_script}
    run os_command_is_installed "docker"
    assert_success

    # shellcheck disable=SC1090
    source ${checks_profile_script}
    # shellcheck disable=SC1090
    source ${instance_env}
    run check_required_instance_env_vars
    assert_success
    # shellcheck disable=SC1090
    source ${workspace_env}
    run check_required_workspace_env_vars
    assert_success

    # shellcheck disable=SC1090
    source ${actions_profile_script}
    unset SSH_KEY_PATH
    assert_empty "${SSH_KEY_PATH}"
    # shellcheck disable=SC2030
    SSH_KEY_PATH="$TEST_DATA/keys/multipass"
    run create_directory_if_not_exists "$SSH_KEY_PATH"
    assert_success

    unset VM_NAME
    assert_empty "${VM_NAME}"
    VM_NAME="TEST_VM"
    run generate_ssh_key
    assert_success
    assert_output -p "id_rsa_$VM_NAME & id_rsa_$VM_NAME.pub keys generated successfully"
}

@test ".check_required_workspace_env_vars fails - when environment variables not set for any of the variables in workspace.env" {
  # shellcheck disable=SC1090
  source ${checks_profile_script}
  # shellcheck disable=SC1090
  source ${workspace_env}
  unset CLOUD_INIT_TEMPLATE
  assert_empty "${CLOUD_INIT_TEMPLATE}"
  run check_required_workspace_env_vars
  assert_failure
  assert_output --partial "CLOUD_INIT_TEMPLATE"
}

@test ".check_required_instance_env_vars - when environment variables not set for any of the variables in instance.env" {
  # shellcheck disable=SC1090
  source ${checks_profile_script}
  # shellcheck disable=SC1090
  source ${instance_env}
  unset VM_NAME
  assert_empty "${VM_NAME}"
  run check_required_instance_env_vars
  assert_failure
  assert_output --partial "VM_NAME"
}

@test ".generate_ssh_key - validate ssk-keygen command available and generate keys with right permission" {
  common_steps
#    # shellcheck disable=SC1090
#    source ${os_profile_script}
#    run os_command_is_installed "ssh-keygen"
#    assert_success
#
#    # shellcheck disable=SC1090
#    source ${checks_profile_script}
#    # shellcheck disable=SC1090
#    source ${instance_env}
#    run check_required_instance_env_vars
#    assert_success
#    # shellcheck disable=SC1090
#    source ${workspace_env}
#    run check_required_workspace_env_vars
#    assert_success
#
#    # shellcheck disable=SC1090
#    source ${actions_profile_script}
#    unset SSH_KEY_PATH
#    assert_empty "${SSH_KEY_PATH}"
#
#    # shellcheck disable=SC2030
#    SSH_KEY_PATH="$TEST_DATA/keys/multipass"
#    run create_directory_if_not_exists "$SSH_KEY_PATH"
#    assert_success
#
#    # Check Key are Generated
#    unset VM_NAME
#    assert_empty "${VM_NAME}"
#    # shellcheck disable=SC2030
#    VM_NAME="TEST_VM"
#    run generate_ssh_key
#    assert_output -p "id_rsa_$VM_NAME & id_rsa_$VM_NAME.pub keys generated successfully"

    # Check Private Key Permission is Right
    run lls "$SSH_KEY_PATH/id_rsa_$VM_NAME"
    assert_output -p "4"
}

@test ".create_cloud_init_config_from_template - create and update cloud-init file" {
  common_steps
#    # shellcheck disable=SC1090
#    source ${os_profile_script}
#    run os_command_is_installed "docker"
#    assert_success
#
#    # shellcheck disable=SC1090
#    source ${checks_profile_script}
#    # shellcheck disable=SC1090
#    source ${instance_env}
#    run check_required_instance_env_vars
#    assert_success
#    # shellcheck disable=SC1090
#    source ${workspace_env}
#    run check_required_workspace_env_vars
#    assert_success
#
#    # shellcheck disable=SC1090
#    source ${actions_profile_script}
#    unset SSH_KEY_PATH
#    assert_empty "${SSH_KEY_PATH}"
#    # shellcheck disable=SC2030
#    SSH_KEY_PATH="$TEST_DATA/keys/multipass"
#    run create_directory_if_not_exists "$SSH_KEY_PATH"
#    assert_success
#
#    unset VM_NAME
#    assert_empty "${VM_NAME}"
#    VM_NAME="TEST_VM"
#    run generate_ssh_key
#    assert_success

    unset CLOUD_INIT_BASE_PATH
    assert_empty "${CLOUD_INIT_BASE_PATH}"

    local CLOUD_INIT_BASE_PATH="$TEST_DATA/config"
    run create_directory_if_not_exists "$CLOUD_INIT_BASE_PATH"

    local SSH_KEY_PATH="$TEST_DATA/keys/multipass"
    run create_cloud_init_config_from_template
    assert_output -p "$CLOUD_INIT_BASE_PATH/${VM_NAME}-cloud-init.yaml Generated for $VM_NAME"

    run file_contains_text "$VM_NAME" "$CLOUD_INIT_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    assert_success

    run file_contains_text "$(cat "$SSH_KEY_PATH/${SSH_KEY}.pub")" "$CLOUD_INIT_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    assert_success

    run file_contains_text "$(whoami)@$DOMAIN" "$CLOUD_INIT_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    assert_success

}


@test "docker wrapper -  interactive mode, print current release" {
    source ${actions_profile_script}
    _docker run --rm -it cytopia/ansible:latest-tools bash -c "cat /etc/alpine-release"
    assert_success
}

@test "._docker - docker wrapper - with Mount Points -  interactive mode, ls mount points and exit" {
    source ${actions_profile_script}
    _docker run --rm -it \
            -v "${PWD}/config":/config \
            cytopia/ansible:latest-tools bash -c "ls -asl /config"
   assert_success
}







