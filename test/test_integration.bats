#!/usr/bin/env ./test/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

profile_script="./src/multipass/checks.bash"
workspace_env="workspace.env"
instance_env="instance.env"

setup() {
    echo "SetUp"
}

teardown() {
  echo "teardown"
}

@test ".check_required_workspace_env_vars fails - when environment variables not set for any of the variables in workspace.env" {
  source ${profile_script}
  source ${workspace_env}
  unset CLOUD_INIT_TEMPLATE
  assert_empty "${CLOUD_INIT_TEMPLATE}"
  run check_required_workspace_env_vars
  assert_failure
  assert_output --partial "CLOUD_INIT_TEMPLATE"
}

@test ".check_required_instance_env_vars - when environment variables not set for any of the variables in instance.env" {
  source ${profile_script}
  source ${instance_env}
  unset VM_NAME
  assert_empty "${VM_NAME}"
  run check_required_instance_env_vars
  assert_failure
  assert_output --partial "VM_NAME"
}