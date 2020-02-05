#!/usr/bin/env sh

#References:
# https://linuxize.com/post/how-to-set-dns-nameservers-on-ubuntu-18-04/
# https://discourse.ubuntu.com/t/troubleshooting-networking-on-macos/12901
# https://github.com/lucaswhitaker22/bash_menus/blob/master/bash_menus/demo.sh

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

help(){
    menu "Multipass Manager" "Provision,SSH,Destroy"
    choice=$?
    case $choice in 
        1) 
            provision 
            ;;
        2) 
            # ssh_config_agent_on_host && ssh bizapps # For Understanding SSH Configuration
            multipass shell $VM_NAME
            ;;
        3) destroy
            ;;
        *) 
            echo "Invalid Input"
            ;;
    esac
}


help





