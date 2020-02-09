#!/usr/bin/env ./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

profile_script="./src/multipass/actions.bash"

setup() {
    echo "SetUp"
    DIR_NAME="keys/multipass"
}

teardown() {
  echo "teardown"
  rm -fr $DIR_NAME #Remove Directory created during Test
}

@test ".create_directory_if_not_exists For Empty Directory Name" {
  source ${profile_script} 
  run create_directory_if_not_exists ""
  assert_success   
}

@test ".create_directory_if_not_exists For valid Directory Name" {
  DIR_NAME="keys/multipass"
  source ${profile_script} 
  run create_directory_if_not_exists "${DIR_NAME}"
  assert_success   
}



