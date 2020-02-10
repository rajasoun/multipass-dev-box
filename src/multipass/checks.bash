#!/usr/bin/env bash

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

# Checks if required env variables for instance is all set
function raise(){
  echo "${1}" >&2
}

function raise_error(){
  echo "${1}" >&2
  exit 1
}

# Wrapper To Aid TDD
function run_main(){
    check_vm_name_required
    check_required_workspace_env_vars 
    check_required_instance_env_vars
}

# Wrapper To Aid TDD
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  run_main
  # shellcheck disable=SC2181
  if [ $? -gt 0 ]
  then
    exit 1
  fi
fi