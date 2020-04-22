#!/usr/bin/env bash

# shellcheck disable=SC1090
source "$(dirname "${BASH_SOURCE[0]}")/os.bash"

function create_cloud_init_config_from_template() {
    local SSH_KEY="id_rsa_${VM_NAME}"
    local CLOUD_INIT_FILE="$CONFIG_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    cp "$CLOUD_INIT_TEMPLATE" "$CLOUD_INIT_FILE"

    #@ToDo: Optimize Edits
    #docker_sed "s,ssh-rsa.*$,$(cat "$SSH_KEY_PATH"/"${SSH_KEY}".pub),g" "/config/${VM_NAME}-cloud-init.yaml"
    #docker_sed  "s,hostname:.*$,hostname:\ $VM_NAME,g" "/config/${VM_NAME}-cloud-init.yaml"

    file_replace_text "ssh-rsa.*$" "$(cat "$SSH_KEY_PATH"/"${SSH_KEY}".pub)" "$CLOUD_INIT_FILE"
    file_replace_text "hostname:.*$" "hostname:\ $VM_NAME" "$CLOUD_INIT_FILE"
    file_replace_text "_rsyslog_ip_port_" "$(get_local_ip):5514" "$CLOUD_INIT_FILE"

    echo "$CLOUD_INIT_FILE Generated for $VM_NAME"
}

function run_main(){
    create_cloud_init_config_from_template
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! run_main "$@"
  then
    exit 1
  fi
fi