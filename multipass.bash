#!/usr/bin/env bash

#References:
# https://linuxize.com/post/how-to-set-dns-nameservers-on-ubuntu-18-04/
# https://discourse.ubuntu.com/t/troubleshooting-networking-on-macos/12901
# https://github.com/lucaswhitaker22/bash_menus/blob/master/bash_menus/demo.sh

function include () {
    if [[ -f "dev.$1" ]]; then
        source "dev.$1"  #source from custom env file if present
    else
        source "$1" #source from deafult env file
    fi
    # shellcheck source=$pwd/src/load
    source "$WORKSPACE/src/load"
}

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
    return "$choice"
}

function check_vm_running(){
  multipass info "$VM_NAME" || raise_error "Exiting.. "
}

function choose_action_from_menu(){
    menu "Multipass Manager" "Provision,SSH-viaMultipass,SSH-viaBastion, Destroy"
    choice=$?
    case $choice in 
        1)  [ $( multipass list | grep -c "$VM_NAME")   -ne 0  ] && raise_error "VM Exists. Exiting..."
            start=$(date +%s)
            provision 
            end=$(date +%s)
            runtime=$((end-start))
            display_time $runtime
            ;;
        2)
            check_vm_running
            multipass shell "$VM_NAME"
            ;;
        3) 
            check_vm_running
            ssh_via_bastion
            ;;
        4) 
            check_vm_running
            destroy
            echo "$VM_NAME Destroyed"
            ;;
        *) 
            echo "Invalid Input"
            ;;
    esac
}

include "instance.env"
check_vm_name_required || exit 1
choose_action_from_menu





