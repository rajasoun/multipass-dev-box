#!/usr/bin/env bash

# Checks if required env variables for instance is all set
function raise(){
  echo "${1}" >&2
}

function raise_error(){
  echo "${1}" >&2
  exit 1
}

# Checks if the VM_NAME environment variable is not Empty or Null
function check_vm_name_required() {
    # Check if vm name is passed as a parameter to script or provided in workspace.env - if not raise error
    [ -z "$VM_NAME" ] && raise "$VM_NAME_NOT_SET_ERR_MSG" && return 1 || echo -e "VM Name :: $VM_NAME"
}

# Checks if required env variables for workspace is all set
function check_required_workspace_env_vars() {
  local required_env="WORKSPACE SSH_CONFIG SSH_KEY_PATH CLOUD_INIT_TEMPLATE "
  local missing_env_vars=""
  for reqvar in $required_env
  do
    if [ -z "${!reqvar}" ]
    then
      raise "missing ENVIRONMENT ${reqvar}!"
      return 1
      missing_env_vars="${missing_env_vars} ${reqvar}"
    fi
  done
}

# Checks if required env variables for instance is all set
function check_required_instance_env_vars() {
  local required_env="VM_NAME DOMAIN CPU MEMORY DISK"
  local missing_env_vars=""
  for reqvar in $required_env
  do
    if [ -z "${!reqvar}" ]
    then
      raise "missing ENVIRONMENT ${reqvar}!"
      return 1
      missing_env_vars="${missing_env_vars} ${reqvar}"
    fi
  done
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
    check_vm_name_required
    check_required_workspace_env_vars 
    check_required_instance_env_vars
    check_vm_running
    raise "$@"
    raise_error "$@"
}

# Wrapper To Aid TDD
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! run_main "$@"
  then
    exit 1
  fi
fi