#!/usr/bin/env bash

function check_vm_name_required() {
    # Check if vm name is passed as a parameter to script or provided in workspace.env - if not exit
    [ -z "$VM_NAME" ] && echo -e $VM_NAME_NOT_SET_ERR_MSG && exit 1 || echo -e "VM Name :: $VM_NAME"
}

function check_required_workspace_env_vars() {
  local required_env="WORKSPACE SSH_CONFIG SSH_KEY_PATH CLOUD_INIT_TEMPLATE "
  local missing_env_vars=""
  for reqvar in $required_env
  do
    if [ -z ${!reqvar} ]
    then
      raise "missing ENVIRONMENT ${reqvar}!"
      return 1
      missing_env_vars="${missing_env_vars} ${reqvar}"
    fi
  done
}

function check_required_instance_env_vars() {
  local required_env="VM_NAME DOMAIN CPU MEMORY DISK"
  local missing_env_vars=""
  for reqvar in $required_env
  do
    if [ -z ${!reqvar} ]
    then
      raise "missing ENVIRONMENT ${reqvar}!"
      return 1
      missing_env_vars="${missing_env_vars} ${reqvar}"
    fi
  done
}


function raise(){
  echo "${1}" >&2
}

function run_main(){
    check_vm_name_required
    check_required_workspace_env_vars 
    check_required_instance_env_vars
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  run_main
  if [ $? -gt 0 ]
  then
    exit 1
  fi
fi