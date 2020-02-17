#!/usr/bin/env ./test/libs/bats/bin/bats
load '../libs/bats-support/load'
load '../libs/bats-assert/load'
load '../helpers'

actions_profile_script="./src/multipass/actions.bash"
workspace_env="workspace.env"
instance_env="instance.env"