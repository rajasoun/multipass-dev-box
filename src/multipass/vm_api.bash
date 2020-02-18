#!/usr/bin/env bash

# shellcheck disable=SC1090
source "$(dirname "${BASH_SOURCE[0]}")/actions.bash"

function provision_vm(){
   [ "$( multipass list | grep -c "$VM_NAME")"   -ne 0  ] && raise_error "VM Exists. Exiting..."
    start=$(date +%s)
    provision
    end=$(date +%s)
    runtime=$((end-start))
    display_time $runtime
}

function provision_bastion(){
  docker pull cytopia/ansible:latest-tools
}

function ssh_to_bastion_vm(){
    check_vm_running
    ssh_via_bastion
}

function ansible_ping_from_bastion_to_vm(){
    check_vm_running
    ansible_ping
}

function configure_vm_from_bastion(){
    check_vm_running
    configure_vm
}

function test_infra(){
  echo "Yet To Be Implemented !!!"
}

function destroy_vm(){
    check_vm_running
    destroy
    echo "$VM_NAME Destroyed"
}

function list_all_vms(){
  list_vms
}

function clear_local_workspace(){
  clear_workspace
}

function vm_api_execute_action(){
    opt="$1"
    choice=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
    case $choice in
        1  | provision_vm)                    provision_vm ;;
        2  | provision_bastion)               provision_bastion ;;
        3  | ansible_ping_from_bastion_to_vm) ansible_ping_from_bastion_to_vm ;;
        4  | ssh_to_bastion_vm)               ssh_to_bastion_vm ;;
        5  | configure_vm_from_bastion)       configure_vm_from_bastion ;;
        6  | test_infra)                      test_infra ;;
        7  | list_all_vms)                    list_all_vms ;;
        8  | destroy_vm)                      destroy_vm ;;
        *)  echo "Invalid Input" ;;
    esac
}

function run_main(){
    provision_vm
    provision_bastion
    ssh_to_bastion_vm
    ansible_ping_from_bastion_to_vm
    configure_vm_from_bastion
    test_infra
    list_all_vms
    destroy_vm
    vm_api_execute_action "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! run_main "$@"
  then
    exit 1
  fi
fi
