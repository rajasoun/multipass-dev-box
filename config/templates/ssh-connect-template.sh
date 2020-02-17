#!/usr/bin/env bash


help(){
  echo "Ansible Ping"
  echo "ansible -i /config/hosts -m ping all"
}

[ -d "$HOME/.ssh/" ] || mkdir -p "$HOME/.ssh/"
eval "$(ssh-agent -s)"
ssh-add -k _private_key_
ssh-keyscan -t rsa _ip_ >> "$HOME/.ssh/known_hosts"

echo "Bastion Server SSH & Ansible Configuration Completed"
echo "ssh -F /config/_ssh_config_  _vm_name_"
echo "                or                "
echo "ssh -i _private_key_  ubuntu@_ip_"
echo "                or                "
echo "ansible -i /config/hosts -m ping all"



