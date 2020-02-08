#!/usr/bin/env ./test/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

profile_script="./src/multipass/os.bash"

setup() {
    echo "SetUp"
    export VM_NAME="TEST_VM_NAME"
}

teardown() {
  echo "teardown"
}


@test ".lls List multipass.bash with Permission" {
  source ${profile_script}
  run lls 
  assert_output --partial "755 -rwxr-xr-x"
}

@test ".os_command_is_installed - check for cd" {
    source ${profile_script}
    run os_command_is_installed brew
    assert_success
}

@test ".os_command_is_installed - check for InValid_Command" {
    source ${profile_script}
    run os_command_is_installed InValid_Command
    assert_failure
}

@test ".display_time - diaplays 60 seconds in mins and seconds" {
    source ${profile_script}
    run display_time 60
    assert_output --partial "1 minutes and 0 seconds"
}


