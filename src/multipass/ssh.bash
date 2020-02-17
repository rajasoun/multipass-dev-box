#!/usr/bin/env bash

# Generates SSH Key
function generate_ssh_key() {
    local SSH_KEY="id_rsa_${VM_NAME}"
    echo -e 'y\n' | ssh-keygen -q -t rsa -C \
                            "$(id -un)@$DOMAIN" -N "" \
                            -f "$SSH_KEY_PATH/${SSH_KEY}" 2>&1 > /dev/null 2>&1
    # Fix Permission For Private Key
    chmod 400 "$SSH_KEY_PATH"/"${SSH_KEY}"
    echo "${SSH_KEY} & ${SSH_KEY}.pub keys generated successfully"
}

function create_ssh_connect_script(){
    local SSH_KEY="id_rsa_${VM_NAME}"
    local SSH_CONNECT_FILE="$CONFIG_BASE_PATH/${VM_NAME}-ssh-connect.sh"
    cp "$SSH_CONNECT_TEMPLATE" "$SSH_CONNECT_FILE"
    chmod a+x "$SSH_CONNECT_FILE"

    IP=$(multipass info "$VM_NAME" | grep IPv4 | awk '{print $2}')
    #@ToDo: Optimize Edits
    #docker_sed "s,_private_key_,/keys/${SSH_KEY},g" "/config/${VM_NAME}-ssh-connect.sh"
    #docker_sed "s,_vm_name_,${VM_NAME},g" "/config/${VM_NAME}-ssh-connect.sh"
    #docker_sed "s,_ssh_config_,${VM_NAME}-ssh-config,g" "/config/${VM_NAME}-ssh-connect.sh"
    #docker_sed "s,_ip_,${IP},g" "/config/${VM_NAME}-ssh-connect.sh"

    file_replace_text "_private_key_" "/keys/${SSH_KEY}"       "$SSH_CONNECT_FILE"
    file_replace_text "_vm_name_"     "${VM_NAME}"            "$SSH_CONNECT_FILE"
    file_replace_text "_ssh_config_"  "${VM_NAME}-ssh-config" "$SSH_CONNECT_FILE"
    file_replace_text "_ip_"          "${IP}"                 "$SSH_CONNECT_FILE"

    local SSH_KEY="id_rsa_${VM_NAME}"
    local SSH_CONFIG="$CONFIG_BASE_PATH/${VM_NAME}-ssh-config"
    ## create ssh-config
    echo -e "Host $VM_NAME\n\tHostname ${IP}\n\tUser ubuntu\n\tIdentityFile /keys/${SSH_KEY}\n" > "$SSH_CONFIG"

    echo "$SSH_CONNECT_FILE & $SSH_CONFIG Generated for $VM_NAME that is Provisioned with $IP"
}

function ssh_via_bastion(){
  _docker run --rm -it --user ansible \
            -v "${PWD}/$SSH_KEY_PATH":/keys \
            -v "${PWD}/$CONFIG_BASE_PATH":/config \
            cytopia/ansible:latest-tools bash -c "source /config/${VM_NAME}-ssh-connect.sh && bash"
}


function run_main(){
    generate_ssh_key
    create_ssh_connect_script
    ssh_via_bastion
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! run_main
  then
    exit 1
  fi
fi