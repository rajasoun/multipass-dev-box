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

@test ".create_cloud_init_config_from_template - create and update cloud-init file - validate text replacements" {
    init_integration_test

    run generate_ssh_key
    assert_success
    assert_output -p "id_rsa_$VM_NAME & id_rsa_$VM_NAME.pub keys generated successfully"

    run create_cloud_init_config_from_template
    assert_output -p "$CONFIG_BASE_PATH/${VM_NAME}-cloud-init.yaml Generated for $VM_NAME"

    run file_contains_text "$VM_NAME" "$CONFIG_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    assert_success

    run file_contains_text "$(cat "$SSH_KEY_PATH/id_rsa_$VM_NAME.pub")" "$CONFIG_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    assert_success

    run file_contains_text "$(id -un)@$DOMAIN" "$CONFIG_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    assert_success

}
