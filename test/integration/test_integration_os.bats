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

@test ".integration.os.file_replace_text - check sed works" {
    init_integration_test
    local SSH_KEY="id_rsa_${VM_NAME}"
    local SSH_CONNECT_FILE="$CONFIG_BASE_PATH/${VM_NAME}-temp-ssh-connect.sh"
    cp "$SSH_CONNECT_TEMPLATE" "$SSH_CONNECT_FILE"

    run file_replace_text "_private_key_" "keys/${SSH_KEY}" "$SSH_CONNECT_FILE"
    assert_success

    run file_contains_text "$SSH_KEY" "$SSH_CONNECT_FILE"
    assert_success
    rm -fr "$SSH_CONNECT_FILE"
}





