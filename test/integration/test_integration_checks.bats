#!/usr/bin/env ./test/libs/bats/bin/bats

load 'init_integration_test'

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

@test ".integration.checks.check_required_workspace_env_vars fails - when environment variables not set for any of the variables in workspace.env" {
  init_integration_test
  unset CLOUD_INIT_TEMPLATE
  assert_empty "${CLOUD_INIT_TEMPLATE}"
  run check_required_workspace_env_vars
  assert_failure
  assert_output --partial "CLOUD_INIT_TEMPLATE"
}

@test ".integration.checks.check_required_instance_env_vars - when environment variables not set for any of the variables in instance.env" {
  init_integration_test
  unset VM_NAME
  assert_empty "${VM_NAME}"
  run check_required_instance_env_vars
  assert_failure
  assert_output --partial "VM_NAME"
}

@test ".integration.checks.check_and_exit_if_vm_exists - check VM exists (Mock Multipass)" {
  init_integration_test
  function multipass(){
      . test/integration/mocks/multipass.bash
  }
  export -f multipass
  run check_and_exit_if_vm_exists
  assert_failure
  assert_output --partial "VM -> $VM_NAME Exists. Exiting..."
}

@test ".integration.checks.check_and_exit_if_vm_not_running - check VM running (Mock Multipass)" {
  init_integration_test
  function multipass(){
      . test/integration/mocks/multipass.bash
  }
  export -f multipass
  run check_and_exit_if_vm_not_running
  assert_success
  assert_output --partial "$VM_NAME"
  assert_output --partial "$Running"
}






