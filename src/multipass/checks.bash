#!/usr/bin/env bash

function check_vm_name_required() {
    # Check if vm name is passed as a parameter to script or provided in workspace.env - if not exit
    [ -z "$VM_NAME" ] && echo -e $VM_NAME_NOT_SET_ERR_MSG && exit 1 || echo -e "VM Name :: $VM_NAME"
}

function run_main(){
    check_vm_name_required
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  run_main
  if [ $? -gt 0 ]
  then
    exit 1
  fi
fi