#!/usr/bin/env bash

# Checks if required env variables for instance is all set
function raise(){
  echo "${1}" >&2
}

function raise_error(){
  echo "${1}" >&2
  exit 1
}

function check_vm_running(){
  multipass info "$VM_NAME" || raise_error "Exiting.. "
}

## Return 1 - 0 if exists and 1 not exists
function check_vm_exists(){
  if [ "$( multipass list | grep -c "$VM_NAME")"   -ne 0  ] 2>/dev/null; then
    echo "VM: $VM_NAME is Provisioned"
    return 0
  else
    echo "VM: $VM_NAME Yet To Be Provisioned."
    return 1
  fi
}

# Wrapper To Aid TDD
function run_main(){
    check_vm_running
    check_vm_exists
}

# Wrapper To Aid TDD
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! run_main "$@"
  then
    exit 1
  fi
fi