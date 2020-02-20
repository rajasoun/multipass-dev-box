#!/usr/bin/env ./test/libs/bats/bin/bats

load 'init_unit_test'

actions_profile_script="./src/multipass/actions.bash"

setup() {
    echo "SetUp"
}

teardown() {
  echo "teardown"
}
