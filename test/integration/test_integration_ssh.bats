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


@test ".integration.generate_ssh_key - validate ssk-keygen command available and generate keys with right permission" {
    init_integration_test

    run generate_ssh_key
    assert_success
    assert_output -p "id_rsa_$VM_NAME & id_rsa_$VM_NAME.pub keys generated successfully"

    # Check Private Key Permission is Right
    run lls "$SSH_KEY_PATH/id_rsa_$VM_NAME"
    assert_output -p "4"

    run file_contains_text "$(id -un)@$DOMAIN" "$SSH_KEY_PATH/id_rsa_$VM_NAME.pub"
    assert_success
}


@test ".integration.create_ssh_connect_script - Validate SSH Connect Script Generation with multipass (mock)" {
  init_integration_test
  multipass_vm_mock_ip="192.168.64.9"

  ## Mocking Multipass info
  function multipass(){
    echo "IPv4:           $multipass_vm_mock_ip"
  }

  export -f multipass
  run create_ssh_connect_script
  assert_success

  assert_output --partial "Generated for $VM_NAME that is Provisioned with $multipass_vm_mock_ip"
  assert_output --partial "$CONFIG_BASE_PATH/${VM_NAME}-ssh-connect.sh & $CONFIG_BASE_PATH/${VM_NAME}-ssh-config"

  run file_contains_text "$VM_NAME" "$CONFIG_BASE_PATH/${VM_NAME}-ssh-config"
  assert_success

  run file_contains_text "$VM_NAME" "$CONFIG_BASE_PATH/${VM_NAME}-ssh-connect.sh"
  assert_success

}