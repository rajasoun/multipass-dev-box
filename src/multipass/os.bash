#!/usr/bin/env bash

# ls, with chmod-like permissions and more.
# @param $1 The directory to ls
function lls() {
  #If Not Paramter is Passed assumes current directory
  local LLS_PATH=${1:-"."}
  # shellcheck disable=SC2012 # Reason: This is for human consumption
  ls -AHl "$LLS_PATH" | awk "{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/) \
                            *2^(8-i));if(k)printf(\"%0o \",k);print}"
}

# Returns true (0) if this the given command/app is installed and on the PATH or false (1) otherwise.
function os_command_is_installed {
  local -r name="$1"
  command -v "$name" > /dev/null
}

# Displays Time in misn and seconds
function display_time {
    local T=$1
    local D=$((T/60/60/24))
    local H=$((T/60/60%24))
    local M=$((T/60%60))
    local S=$((T%60))
    (( D > 0 )) && printf '%d days ' $D
    (( H > 0 )) && printf '%d hours ' $H
    (( M > 0 )) && printf '%d minutes ' $M
    (( D > 0 || H > 0 || M > 0 )) && printf 'and '
    printf '%d seconds\n' $S
}

# Returns true (0) if the given file exists and is a file and false (1) otherwise
function file_exists() {
  local -r file="$1"
  [[ -f "$file" ]]
}

# Returns true (0) if the given file exists contains the given text and false (1) otherwise. The given text is a
# regular expression.
function file_contains_text {
  local -r text="$1"
  local -r file="$2"
  grep -q "$text" "$file"
}

function run_main() {
    lls "$@"
    os_command_is_installed "$@"
    display_time "$@"
    file_exists "$@"
    file_contains_text "$@"
    os
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! run_main "$@"
  then
    exit 1
  fi
fi