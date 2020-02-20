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

@test ".integration.actions.provision - Provision VM (Mock Multipass)" {
    init_integration_test
    ### Mock Multipass
    function multipass(){
        . test/integration/mocks/multipass.bash
    }
    export -f multipass
    run provision
    assert_success
    assert_output --partial "Launched: $VM_NAME"
    run file_contains_text "$VM_NAME" "$CONFIG_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    assert_success

    run file_contains_text "$(cat "$SSH_KEY_PATH/id_rsa_$VM_NAME.pub")" "$CONFIG_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    assert_success

    run file_contains_text "$(id -un)@$DOMAIN" "$CONFIG_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    assert_success

}

@test ".integration.actions.list_vms - list_vms (Mock Multipass)" {
   init_integration_test
    ### Mock Multipass
    function multipass(){
        . test/integration/mocks/multipass.bash
    }
    export -f multipass
    run list_vms
    assert_success
    assert_output -p "$VM_NAME"
    assert_output -p "Running"
}

@test ".integration.actions.destroy - destroy VM (Mock Multipass)" {
   init_integration_test
    ### Mock Multipass
    function multipass(){
        . test/integration/mocks/multipass.bash
    }
    export -f multipass
    run destroy
    assert_success
    # File should have been deleted
    run file_exists "$CONFIG_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    assert_failure
}