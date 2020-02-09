#!/usr/bin/env ./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

actions_profile_script="./src/multipass/actions.bash"

setup() {
    echo "SetUp"
}

teardown() {
  echo "teardown"
}

@test ".create_directory_if_not_exists For Empty Directory Name" {
  source ${actions_profile_script} 
  run create_directory_if_not_exists ""
  assert_success   
}

@test ".create_directory_if_not_exists For valid Directory Name" {
  source ${actions_profile_script} 
  run create_directory_if_not_exists "${SSH_TEST_KEY_PATH}"
  assert_success   
}




