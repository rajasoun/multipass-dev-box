#!/usr/bin/env bash

function execute_action(){
    opt="$1"
    choice=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
    case $choice in
        1  | provision_vm)                    provision_vm ;;
        2  | provision_bastion)               provision_bastion ;;
        3  | ansible_ping_from_bastion_to_vm) ansible_ping_from_bastion_to_vm ;;
        4  | ssh_to_bastion_vm)               ssh_to_bastion_vm ;;
        5  | configure_vm_from_bastion)       configure_vm_from_bastion ;;
        6  | test_infra)                      test_infra ;;
        7  | destroy_vm)                      destroy_vm ;;
        *)  echo "Invalid Input" ;;
    esac
}

function run_main(){
  execute_action "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! run_main "$@"
  then
    exit 1
  fi
fi