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
    export CONFIG_BASE_PATH
    export VM_NAME
    export SSH_KEY_PATH
    ssh_via_bastion
}

function ansible_ping_from_bastion_to_vm(){
    check_vm_running
    export CONFIG_BASE_PATH
    export VM_NAME
    export SSH_KEY_PATH
    ansible_ping
}

function configure_vm_from_bastion(){
    check_vm_running
    ## Explicitly exporting to make it available in docket-compose
    export CONFIG_BASE_PATH
    export VM_NAME
    export SSH_KEY_PATH
    configure_vm
}

function test_base_infra(){
  check_vm_running
  ## Explicitly exporting to make it available in docket-compose
  export CONFIG_BASE_PATH
  export VM_NAME
  export SSH_KEY_PATH
  STAGE="-m base"
  export STAGE
  docker-compose -f test/py.test/docker-compose.yml run  --rm service
}

function test_infra(){
  check_vm_running
  ## Explicitly exporting to make it available in docket-compose
  export CONFIG_BASE_PATH
  export VM_NAME
  export SSH_KEY_PATH
  STAGE=
  export STAGE
  docker-compose -f test/py.test/docker-compose.yml run  --rm service
}

function destroy_vm(){
    check_vm_running
    destroy
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
        10  | provision_vm)                    provision_vm ;;
        20  | provision_bastion)               provision_bastion ;;
        30  | ansible_ping_from_bastion_to_vm) ansible_ping_from_bastion_to_vm ;;
        40  | ssh_to_bastion_vm)               ssh_to_bastion_vm ;;
        50  | configure_vm_from_bastion)       configure_vm_from_bastion ;;
        60  | test_base_infra)                 test_base_infra ;;
        70  | test_infra)                      test_infra ;;
        80  | list_all_vms)                    list_all_vms ;;
        90  | destroy_vm)                      destroy_vm ;;
        *)  echo "Invalid Input" ;;
    esac
}

function run_main(){
    provision_vm
    provision_bastion
    ssh_to_bastion_vm
    ansible_ping_from_bastion_to_vm
    configure_vm_from_bastion
    test_base_infra
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
