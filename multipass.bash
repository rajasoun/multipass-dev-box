#!/usr/bin/env bash

#References:
# https://linuxize.com/post/how-to-set-dns-nameservers-on-ubuntu-18-04/
# https://discourse.ubuntu.com/t/troubleshooting-networking-on-macos/12901
# https://github.com/lucaswhitaker22/bash_menus/blob/master/bash_menus/demo.sh

source "instance.env"
source "workspace.env"

# shellcheck disable=SC1090
source "$WORKSPACE/src/load"

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

choose_action_from_menu(){
    menu "Multipass Manager" "Provision,SSH-Multipass,SSH-Host, Destroy"
    choice=$?
    case $choice in 
        1) .
            start=$(date +%s)
            provision 
            end=$(date +%s)
            runtime=$((end-start))
            display_time $runtime
            ;;
        2) 
            multipass shell "$VM_NAME"
            ;;
        3) 
            multipass info "$VM_NAME" || exit 1 #Exit if VM Not Running
            ssh_config_agent_on_host
            eval "$(ssh-agent -s)"
            ;;
        4) 
            multipass info "$VM_NAME" || exit 1 #Exit if VM Not Running
            destroy
            echo "$VM_NAME Destroyed"
            ;;
        *) 
            echo "Invalid Input"
            ;;
    esac
}

check_vm_name_required || exit 1
choose_action_from_menu





