#!/usr/bin/env bash

function check_vm_name_required() {
    # Check if vm name is passed as a parameter to script or provided in workspace.env - if not exit
    [ -z "$VM_NAME" ] && echo -e $VM_NAME_NOT_SET_ERR_MSG && exit 1 || echo -e "VM Name :: $VM_NAME"
}

function check_required_environment_vars() {
  local required_env=$1
  for reqvar in $required_env
  do
    if [ -z ${!reqvar} ]
    then
      raise "missing ENVIRONMENT ${reqvar}!"
      return 1
    fi
  done
}

function check_required_workspace_env_vars(){
  check_required_environment_vars "WORKSPACE SSH_CONFIG SSH_KEY_PATH SSH_KEY CLOUD_INIT_TEMPLATE CLOUD_INIT_FILE"
  
}

function run_main(){
    check_vm_name_required
    check_required_environment_vars 

}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  run_main
  if [ $? -gt 0 ]
  then
    exit 1
  fi
fi