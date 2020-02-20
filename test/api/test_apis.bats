#!/usr/bin/env ./test/libs/bats/bin/bats

load 'init_api_test'

setup() {
    echo "SetUp"
    TEST_DATA="test/.test_data"
    # This block will run only for the first test in this file.
    # Usefull for setting up resources that should last for all tests.
    if [[ "$BATS_TEST_NUMBER" -eq 1 ]]; then
        echo "SetUp Once - For Entire Test Suite At the Begining"
        rm -fr "$TEST_DATA" #Remove Directory created during Test
    fi
}

teardown() {
  echo "teardown"
  # This block will run only for the last test case in this file.
  # Usefull for tearing down global resources.
  if [[ "${#BATS_TEST_NAMES[@]}" -eq "$BATS_TEST_NUMBER" ]]; then
    echo "Teardown Once for Entire Test Suite at the End"
    ## if vm not destroyed due to failure in the tests ensure its destroyed at the end
    if [[ "$( multipass list | grep -c "$VM_NAME")"  -ne 0  ]]; then
      init_api_test
      run vm_api_execute_action destroy_vm
    fi
    rm -fr "$TEST_DATA" #Remove Directory created during Test
  fi
}

@test ".api.ansible_ping_from_bastion_to_vm - .failure_check  ping should fail on non existent vm" {
  init_api_test
  run vm_api_execute_action ansible_ping_from_bastion_to_vm
  assert_output --partial "does not exist"
  assert_output --partial "Exiting.."
  assert_failure
}

@test ".api.configure_vm_from_bastion - .failure_check  configuration should fail on non existent vm" {
  init_api_test
  run vm_api_execute_action configure_vm_from_bastion
  assert_output --partial "does not exist"
  assert_output --partial "Exiting.."
  assert_failure
}

@test ".api.test_infra - .failure_check test vm should fail on non existent vm" {
  init_api_test
  run vm_api_execute_action test_infra
  assert_success
  assert_output --partial "Yet To Be Implemented !!!"
}

@test ".api.list_all_vms - .failure_check list all vms should not list the VM" {
  init_api_test
  run vm_api_execute_action list_all_vms
  assert_success
  refute_output  "$VM_NAME"
  refute_output  "Running"
}

@test ".destroy_vm - .failure_check  - destroy_vm on non provision vm should error out" {
  init_api_test
  run vm_api_execute_action destroy_vm
  assert_output --partial "does not exist"
  assert_output --partial "Exiting.."
  assert_failure
}

@test ".api.provision_vm - provision vm (Long Running)" {
  init_api_test
  run vm_api_execute_action provision_vm
  assert_success
  assert_output --partial "VM Creation Sucessfull"
  assert_output --partial "Next: SSH to $VM_NAME via Multipass or Bastion Host"
}

@test ".api.provision_vm - .failure_check provisioning vm that is already provisioned errors out correctly" {
  init_api_test
  run vm_api_execute_action provision_vm
  assert_failure
  assert_output --partial "VM Exists. Exiting..."
}

@test ".api.provision_vm - check vm running" {
  init_api_test
  run check_vm_running
  assert_success
  assert_output --partial "$VM_VM_NAME"
  assert_output --partial "Running"
}

@test ".api.provision_bastion - provision bastion (docker pull)" {
  init_api_test
  run vm_api_execute_action provision_bastion
  assert_success
  assert_output --partial "docker.io/cytopia/ansible:latest-tools"
}

@test ".api.ansible_ping_from_bastion_to_vm - ping VM from bastion through ansible" {
  init_api_test
  run vm_api_execute_action ansible_ping_from_bastion_to_vm
  assert_success
  assert_output --partial "Connection SUCCESS :: Ansible Control Center -> VM"
  assert_output --partial "$VM_NAME | SUCCESS"
}

@test ".api.configure_vm_from_bastion - configure vm from bastion through ansible (Long Running)" {
  init_api_test
  run vm_api_execute_action configure_vm_from_bastion
  assert_success
  assert_output --partial "failed=0"
  assert_output --partial "VM Configration SUCCESSFULL"
}

@test ".api.test_infra - test vm that's been configured via ansible - using testinfra" {
  init_api_test
  run vm_api_execute_action test_infra
  assert_success
  assert_output --partial "Yet To Be Implemented !!!"
}

@test ".api.list_all_vms - list all vms" {
  init_api_test
  run vm_api_execute_action list_all_vms
  assert_success
  assert_output --partial "$VM_NAME"
  assert_output --partial "Running"
}

@test ".api.destroy_vm - destroy_vm and check if workspace clean up is successfull" {
  init_api_test
  run vm_api_execute_action destroy_vm
  assert_success
  assert_output --partial "$VM_NAME"
}

@test ".api.list_all_vms - .failure_check list all vms should not list the VM after destroy_vm" {
  init_api_test
  run vm_api_execute_action list_all_vms
  assert_success
  refute_output  "$VM_NAME"
  refute_output  "Running"
}








