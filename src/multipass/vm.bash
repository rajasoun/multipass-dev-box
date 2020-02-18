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

