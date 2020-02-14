#!/usr/bin/env ./test/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

profile_script="./src/multipass/os.bash"

setup() {
    echo "SetUp"
    export VM_NAME="TEST_VM_NAME"
    # shellcheck disable=SC1090
    source ${profile_script}
}

teardown() {
  echo "teardown"
}

@test ".lls List with Permission for ReadMe.md" {
  run lls
  assert_output --partial "644 -rw-r--r--"
}

@test ".os_command_is_installed - check for cd" {
    run os_command_is_installed cd
    assert_success
}

@test ".os_command_is_installed - check for ssh-keygen" {
    run os_command_is_installed ssh-keygen
    assert_success
}

@test ".os_command_is_installed - check for docker" {
    run os_command_is_installed docker
    assert_success
}

@test ".os_command_is_installed - check for InValid_Command" {
    run os_command_is_installed InValid_Command
    assert_failure
}

@test ".display_time - diaplays 60 seconds in mins and seconds" {
    run display_time 60
    assert_output --partial "1 minutes and 0 seconds"
}

@test ".display_time - diaplays 0 seconds in mins and seconds" {
    run display_time 0
    assert_output --partial "0 seconds"
}

@test ".file_exists - Checks if ./src/multipass/os.bash File exists" {
    run file_exists  ${profile_script}
    assert_success
}

@test ".file_exists - Checks if  File SHOULD_NOT_BE_THERE not exists" {
    run file_exists  "SHOULD_NOT_BE_THERE"
    assert_failure
}

@test ".file_contains_text - Checks if text 'Displays Time'  exists in  ./src/multipass/os.bash File" {
    run file_contains_text "Displays Time" ${profile_script}
    assert_success
}

@test ".file_contains_text - Checks if text 'SHOULD_NOT_EXIST'  in  ./src/multipass/os.bash File" {
    run file_contains_text "SHOULD_NOT_EXIST" ${profile_script}
    assert_failure
}


