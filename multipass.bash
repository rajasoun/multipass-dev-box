#!/usr/bin/env bash

#References:
# https://linuxize.com/post/how-to-set-dns-nameservers-on-ubuntu-18-04/
# https://discourse.ubuntu.com/t/troubleshooting-networking-on-macos/12901
# https://github.com/lucaswhitaker22/bash_menus/blob/master/bash_menus/demo.sh

source "workspace.env"
source "$WORKSPACE/libs/helpers/load"


### Arguments with Default Values
VM_NAME=${1:-"bizapps"}
CPU=${2:-"1"}
MEMORY=${3:-"2G"}
DISK=${4:-"5G"}

SSH_CONFIG="config/ssh-config"
SSH_KEY_PATH="$HOME/.ssh/multipass"
SSH_KEY="id_rsa_${VM_NAME}"
CLOUD_INIT_TEMPLATE="config/cloud-init-template.yaml"
CLOUD_INIT_FILE="config/${VM_NAME}-cloud-init.yaml"

function menu() {
    tput clear
    title=$1
    in=$2
    arr=$(echo $in | tr "," "\n")
    x=1
    y=1
    
    tput cup $y $x
    tput rev;echo " $title "; tput sgr0
    x=$((x+${#title}+4))
    i=0
    for n in $arr
    do
        tput cup $(( y+$i )) $x
            str="$n" 
            echo "$((i+1)). $str"
        i=$((i+1))
    done
    tput cup $(( y+$i+1 )) $((x-$((${#title}+4))))
    read -p "Enter your choice [1-$i] " choice
    return $choice
}

help(){
    menu "Multipass Manager" "Provision,SSH-Multipass,SSH-Host, Destroy"
    choice=$?
    case $choice in 
        1) 
            provision 
            ;;
        2) 
            multipass shell $VM_NAME
            ;;
        3) 
            multipass info $VM_NAME || exit 1 #Exit if VM Not Running
            ssh_config_agent_on_host
            ;;
        4) 
            multipass info $VM_NAME || exit 1 #Exit if VM Not Running
            destroy
            echo "$VM_NAME Destroyed"
            ;;
        *) 
            echo "Invalid Input"
            ;;
    esac
}


help





