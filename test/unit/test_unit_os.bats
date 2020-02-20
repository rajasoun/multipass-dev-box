#!/usr/bin/env ./test/libs/bats/bin/bats

load 'init_unit_test'

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


@test ".create_directory_if_not_exists For Empty Directory Name" {
  # shellcheck disable=SC1090
  source ${actions_profile_script}
  run create_directory_if_not_exists ""
  assert_failure
}

@test ".lls List with Permission for ReadMe.md" {
  run lls
  assert_output --partial "r--"
}

@test ".os_command_is_installed - check for cd" {
    run os_command_is_installed cd
    assert_success
}

@test ".os_command_is_installed - check for ssh-keygen" {
    run os_command_is_installed ssh-keygen
    assert_success
}

@test ".os_command_is_installed - check for sed" {
    run os_command_is_installed sed
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

@test ".file_replace_text empty file" {
  # shellcheck disable=SC2155
  local readonly tmp_file=$(mktemp)
  local readonly original_regex="foo"
  local readonly replacement="bar"

  run file_replace_text "$original_regex" "$replacement" "$tmp_file"
  assert_success

  # shellcheck disable=SC2155
  local readonly actual=$(cat "$tmp_file")
  local readonly expected=""
  assert_equal "$expected" "$actual"

  rm -f "$tmp_file"
}

@test ".file_replace_text non empty file, no match" {
  # shellcheck disable=SC2155
  local readonly tmp_file=$(mktemp)
  local readonly original_regex="foo"
  local readonly replacement="bar"
  local readonly file_contents="not a match"

  echo "$file_contents" > "$tmp_file"

  run file_replace_text "$original_regex" "$replacement" "$tmp_file"
  assert_success

  # shellcheck disable=SC2155
  local readonly actual=$(cat "$tmp_file")
  local readonly expected="$file_contents"
  assert_equal "$expected" "$actual"

  rm -f "$tmp_file"
}

@test ".file_replace_text non empty file, exact match" {
  # shellcheck disable=SC2155
  local readonly tmp_file=$(mktemp)
  local readonly original_regex="abc foo def"
  local readonly replacement="bar"
  local readonly file_contents="abc foo def"

  echo "$file_contents" > "$tmp_file"

  run file_replace_text "$original_regex" "$replacement" "$tmp_file"
  assert_success

  # shellcheck disable=SC2155
  local readonly actual=$(cat "$tmp_file")
  local readonly expected="$replacement"
  assert_equal "$expected" "$actual"

  rm -f "$tmp_file"
}

@test ".file_replace_text non empty file, regex match" {
  # shellcheck disable=SC2155
  local readonly tmp_file=$(mktemp)
  local readonly original_regex=".*foo.*"
  local readonly replacement="bar"
  local readonly file_contents="abc foo def"

  echo "$file_contents" > "$tmp_file"

  run file_replace_text "$original_regex" "$replacement" "$tmp_file"
  assert_success

  # shellcheck disable=SC2155
  local readonly actual=$(cat "$tmp_file")
  # shellcheck disable=SC2034
  local readonly expected="$replacement"
  assert_equal "$expected" "$actual"

  rm -f "$tmp_file"
}


