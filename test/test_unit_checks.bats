#!/usr/bin/env ./test/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

profile_script="./src/multipass/checks.bash"

setup() {
    echo "SetUp"
    export VM_NAME="TEST_VM_NAME"
}

teardown() {
  echo "teardown"
}

@test ".check_vm_name_required fails when VM_NAME environment variable not set" {
  unset VM_NAME
  assert_empty "${VM_NAME}"
  source ${profile_script}
  run check_vm_name_required
  assert_failure
}

@test ".check_vm_name_required succeeds when VM_NAME environment variable  set" {
  unset VM_NAME
  assert_empty "${VM_NAME}"
  export VM_NAME="TEST_VM_NAME"
  source ${profile_script}
  run check_vm_name_required
  assert_output --partial "VM Name :: $VM_NAME"
}