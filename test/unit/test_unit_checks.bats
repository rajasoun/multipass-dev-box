#!/usr/bin/env ./test/libs/bats/bin/bats

load '../libs/bats-support/load'
load '../libs/bats-assert/load'
load '../helpers'

profile_script="./src/multipass/checks.bash"

setup() {
    echo "SetUp"
    export VM_NAME="TEST_VM_NAME"
}

teardown() {
  echo "teardown"
  unset VM_NAME
}

@test ".check_vm_name_required - when VM_NAME environment variable  set" {
  unset VM_NAME
  assert_empty "${VM_NAME}"
  # shellcheck disable=SC2030
  export VM_NAME="TEST_VM_NAME"
  # shellcheck disable=SC1090
  source ${profile_script}
  run check_vm_name_required
  assert_output --partial "VM Name :: $VM_NAME"
}

@test ".check_vm_name_required - when VM_NAME environment variable not set" {
  unset VM_NAME
  # shellcheck disable=SC2031
  assert_empty "${VM_NAME}"
  # shellcheck disable=SC1090
  source ${profile_script}
  run check_vm_name_required
  assert_failure
}

@test ".check_required_workspace_env_vars - when environment variables not set for SSH_CONFIG" {
  unset SSH_CONFIG
  assert_empty "${SSH_CONFIG}"
  # shellcheck disable=SC1090
  source ${profile_script}
  run check_required_workspace_env_vars
  assert_failure
  assert_output --partial "missing"
}

@test ".check_required_instance_env_vars - when environment variables not set for VM_NAME" {
  unset VM_NAME
  # shellcheck disable=SC2031
  assert_empty "${VM_NAME}"
  # shellcheck disable=SC1090
  source ${profile_script}
  run check_required_instance_env_vars
  assert_failure
  assert_output --partial "VM_NAME"
}