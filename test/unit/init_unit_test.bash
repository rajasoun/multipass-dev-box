#!/usr/bin/env ./test/libs/bats/bin/bats
load '../libs/bats-support/load'
load '../libs/bats-assert/load'
load '../helpers'

actions_profile_script="./src/multipass/actions.bash"
instance_env="instance.env"

function init_unit_test(){
  # shellcheck source=./src/multipass/actions.bash
  source "$actions_profile_script"
  # shellcheck source=instance.env
  source "$instance_env"
}
