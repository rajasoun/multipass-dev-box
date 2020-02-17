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

@test ".create_ansible_inventory_from_template - create and update Ansible Inventory - validate text replacements" {
    init_integration_test

    multipass_vm_mock_ip="192.168.64.9"
    ## Mocking Multipass info
    function multipass(){
      echo "IPv4:           $multipass_vm_mock_ip"
    }
    export -f multipass

    run create_ansible_inventory_from_template
    assert_success
    assert_output -p "generated for ${VM_NAME} that is Provisioned with ${multipass_vm_mock_ip}"

    run file_contains_text "$VM_NAME" "$CONFIG_BASE_PATH/hosts"
    assert_success

    run file_contains_text "$multipass_vm_mock_ip" "$CONFIG_BASE_PATH/hosts"
    assert_success

    run file_contains_text "/keys/${SSH_KEY}" "$CONFIG_BASE_PATH/hosts"
    assert_success

}
