#!/usr/bin/env bash

## Menu
## Parameters Title and Options
## Usage: menu "VM Manager" "Provision,SSH-Bastion,AnsiblePing,ConfigureVM,Destroy"
function menu() {
    tput clear
    title=$1
    in=$2
    arr=$(echo "$in" | tr "," "\n")
    x=1
    y=1

    tput cup $y $x
    tput rev;echo " $title "; tput sgr0
    x=$((x+${#title}+4))
    i=0
    for n in $arr
    do
        # shellcheck disable=SC2004
        tput cup $(( y+$i )) $x
            str="$n"
            echo "$((i+1)). $str"
        i=$((i+1))
    done
    # shellcheck disable=SC2004
    tput cup $(( y+$i+1 )) $((x-$((${#title}+4))))
    # shellcheck disable=SC2162
    read -p "Enter your choice [1-$i] " choice

    [ -n "$choice" ] && [ "$choice" -eq "$choice" ] 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "$choice is not number..."
        choice="999"
    fi
    return "$choice"
}

function choose_action_from_menu(){
    menu "VM Manager" "Provision,SSH-Bastion,AnsiblePing,ConfigureVM,TestInfra,Destroy"
    opt=$?
    choice=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
    case $choice in
        1) provision_vm ;;
        2) ssh_to_bastion_vm ;;
        3) ansible_ping_from_bastion_to_vm ;;
        4) configure_vm_from_bastion ;;
        5) test_infra ;;
        6) destroy_vm ;;
        *) echo "Invalid Input" ;;
    esac
}

function choose_action_from_help(){
    clear
    cat docs/1_iaac_simple.txt
    echo "Enter your choice: "
    read -r opt
    choice=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
    case $choice in
        1)  provision_vm ;;
        2a) provision_bastion ;;
        2b) ansible_ping_from_bastion_to_vm ;;
        3)  configure_vm_from_bastion ;;
        4)  test_infra ;;
        5)  destroy_vm ;;
        *)  echo "Invalid Input" ;;
    esac
}

function run_main(){
    menu "$@"
    choose_action_from_menu
    choose_action_from_help
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! run_main "$@"
  then
    exit 1
  fi
fi