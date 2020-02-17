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

function ansible_ping(){
  CMD="source /config/${VM_NAME}-ssh-connect.sh && ansible -i /config/hosts -m ping all"
  _docker run --rm -it --user ansible \
            -v "${PWD}/$SSH_KEY_PATH":/keys \
            -v "${PWD}/$ANSIBLE_BASE_PATH":/ansible \
            -v "${PWD}/$CONFIG_BASE_PATH":/config \
            cytopia/ansible:latest-tools bash -c "$CMD"

  case "$?" in
    0)
        echo "Connection SUCCESS :: Ansible Control Center -> VM ";;
    1)
        echo "Error... Ansible Control Center Can Not Reach VM via SSH" ;;
  esac
}

function configure_vm(){
  PLAYBOOK="/ansible/simple_playbook.yml"
  CMD="source /config/${VM_NAME}-ssh-connect.sh && ansible-playbook  -i /config/hosts -v $PLAYBOOK"

  _docker run --rm -it --user ansible \
            -v "${PWD}/$SSH_KEY_PATH":/keys \
            -v "${PWD}/$ANSIBLE_BASE_PATH":/ansible \
            -v "${PWD}/$CONFIG_BASE_PATH":/config \
            cytopia/ansible:latest-tools bash -c "$CMD"

  case "$?" in
    0)
        echo "VM Configration SUCCESSFULL " ;;
    1)
        echo "VM Configration FAILED " ;;
  esac
}

function run_main(){
  create_ansible_inventory_from_template
  ansible_ping
  configure_vm
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! run_main
  then
    exit 1
  fi
fi