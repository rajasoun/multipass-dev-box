#!/usr/bin/env bash

[ -d "$HOME/.ssh/" ] || mkdir -p "$HOME/.ssh/"
eval "$(ssh-agent -s)"
ssh-add -k _private_key_
ssh-keyscan -t rsa _ip_ >> "$HOME/.ssh/known_hosts"

echo "Bastion Server SSH Configuration Completed"
echo "ssh -F /config/_ssh_config_  _vm_name_"
echo "                or                "
echo "ssh -i _private_key_  ubuntu@_ip_"

