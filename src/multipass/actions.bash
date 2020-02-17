#!/usr/bin/env bash

# shellcheck disable=SC1090
source "$(dirname "${BASH_SOURCE[0]}")/os.bash"
source "$(dirname "${BASH_SOURCE[0]}")/ssh.bash"
source "$(dirname "${BASH_SOURCE[0]}")/cloud_init.bash"
source "$(dirname "${BASH_SOURCE[0]}")/docker_wrapper.bash"

function provision(){
    check_required_workspace_env_vars
    check_required_instance_env_vars

    create_directory_if_not_exists "$SSH_KEY_PATH"
    generate_ssh_key
    create_cloud_init_config_from_template "$VM_NAME"

    local CLOUD_INIT_FILE="$CONFIG_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    ## Exit if Launch Fails
    multipass launch -c"$CPU" -m"$MEMORY" -d"$DISK" -n "$VM_NAME" lts --cloud-init "$CLOUD_INIT_FILE" || exit
    IP=$(multipass info "$VM_NAME" | grep IPv4 | awk '{print $2}')

    create_ssh_connect_script
    create_ansible_inventory_from_template

    echo "VM Creation Sucessfull"
    echo "VM Name : $VM_NAME |  IP: $IP "
    echo "Next: SSH to $VM_NAME via Multipass or Bastion Host"
}

function destroy(){
    IP=$(multipass info "$VM_NAME" | grep IPv4 | awk '{print $2}')
    # delete old key from known_hosts
    #docker_sed "/${IP}/d" /known_hosts

    multipass delete "$VM_NAME" && multipass purge
    clear_workspace
}

function clear_workspace(){
    rm -fr "$CONFIG_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    rm -fr "$CONFIG_BASE_PATH/${VM_NAME}-ssh-config"
    rm -fr "$CONFIG_BASE_PATH/${VM_NAME}-ssh-connect.sh"
    rm -fr "$CONFIG_BASE_PATH/hosts"
    rm -fr "$SSH_KEY_PATH"
}

function list_vms(){
    multipass ls
}

function run_main(){
    provision
    list_vms
    clear_workspace
    destroy
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! run_main
  then
    exit 1
  fi
fi