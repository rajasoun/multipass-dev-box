#!/usr/bin/env ./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

profile_script="./src/multipass/actions.bash"

setup() {
    echo "SetUp"
}

teardown() {
  echo "teardown"
}





