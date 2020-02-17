#!/usr/bin/env bash


function create_ansible_inventory_from_template(){
    local SSH_KEY="id_rsa_${VM_NAME}"

    local ANSIBLE_INVENTORY_FILE="$CONFIG_BASE_PATH/hosts"
    cp "$ANSIBLE_INVENTORY_TEMPLATE" "$ANSIBLE_INVENTORY_FILE"

    IP=$(multipass info "$VM_NAME" | grep IPv4 | awk '{print $2}')
    #@ToDo: Optimize Edits
    file_replace_text "_sshkey_" "/keys/${SSH_KEY}"        "$ANSIBLE_INVENTORY_FILE"
    file_replace_text "_vm_name_"     "${VM_NAME}"              "$ANSIBLE_INVENTORY_FILE"
    file_replace_text "_ip_"          "${IP}"                   "$ANSIBLE_INVENTORY_FILE"

    echo "Ansibel Inventory -> ${ANSIBLE_INVENTORY_FILE} generated for ${VM_NAME} that is Provisioned with ${IP}"
}

function run_main(){
  create_ansible_inventory_from_template
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! run_main
  then
    exit 1
  fi
fi