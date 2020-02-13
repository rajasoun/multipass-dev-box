#!/usr/bin/env bash

function create_directory_if_not_exists(){
    DIR_NAME=$1
    ## Create Directory If Not Exists
    if [ ! -d "$DIR_NAME"  ]; then
      mkdir -p "$DIR_NAME"
    fi
}

function generate_ssh_key() {
    local SSH_KEY="id_rsa_${VM_NAME}"
    echo -e 'y\n' | ssh-keygen -q -t rsa -C \
                            "$(whoami)@$DOMAIN" -N "" \
                            -f "$SSH_KEY_PATH/${SSH_KEY}" 2>&1 > /dev/null 2>&1
    # Fix Permission For Private Key
    chmod 400 "$SSH_KEY_PATH"/"${SSH_KEY}"
    echo "${SSH_KEY} & ${SSH_KEY}.pub keys generated successfully"
}

function create_cloud_init_config_from_template() {
    local SSH_KEY="id_rsa_${VM_NAME}"
    local CLOUD_INIT_FILE="$CONFIG_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    cp "$CLOUD_INIT_TEMPLATE" "$CLOUD_INIT_FILE"

    #@ToDo: Optimize Edits
    docker_sed "s,ssh-rsa.*$,$(cat "$SSH_KEY_PATH"/"${SSH_KEY}".pub),g" "/config/${VM_NAME}-cloud-init.yaml"
    docker_sed  "s,hostname:.*$,hostname:\ $VM_NAME,g" "/config/${VM_NAME}-cloud-init.yaml"

    echo "$CLOUD_INIT_FILE Generated for $VM_NAME"
}

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

    echo "VM Creation Sucessfull"
    echo "VM Name : $VM_NAME |  IP: $IP "
    echo "Next: SSH to $VM_NAME via Multipass or Bastion Host"
}

function create_ssh_connect_script(){
    local SSH_KEY="id_rsa_${VM_NAME}"
    local SSH_CONNECT_FILE="$CONFIG_BASE_PATH/${VM_NAME}-ssh-connect.sh"
    cp "$SSH_CONNECT_TEMPLATE" "$SSH_CONNECT_FILE"
    chmod a+x "$SSH_CONNECT_FILE"

    IP=$(multipass info "$VM_NAME" | grep IPv4 | awk '{print $2}')
    #@ToDo: Optimize Edits
    docker_sed "s,_private_key_,/keys/${SSH_KEY},g" "/config/${VM_NAME}-ssh-connect.sh"
    docker_sed "s,_vm_name_,${VM_NAME},g" "/config/${VM_NAME}-ssh-connect.sh"
    docker_sed "s,_ssh_config_,${VM_NAME}-ssh-config,g" "/config/${VM_NAME}-ssh-connect.sh"
    docker_sed "s,_ip_,${IP},g" "/config/${VM_NAME}-ssh-connect.sh"

    local SSH_KEY="id_rsa_${VM_NAME}"
    local SSH_CONFIG="$CONFIG_BASE_PATH/${VM_NAME}-ssh-config"
    ## create ssh-config
    echo -e "Host $VM_NAME\n\tHostname ${IP}\n\tUser ubuntu\n\tIdentityFile /keys/${SSH_KEY}\n" > "$SSH_CONFIG"

    echo "$SSH_CONNECT_FILE & $SSH_CONFIG Generated for $VM_NAME that is Provisioned with $IP"
}

function ssh_via_bastion(){
  create_ssh_connect_script
  _docker run --rm -it --user ansible \
            -v "${PWD}/$SSH_KEY_PATH":/keys \
            -v "${PWD}/$CONFIG_BASE_PATH":/config \
            cytopia/ansible:latest-tools bash -c "source /config/${VM_NAME}-ssh-connect.sh && bash"
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
    rm -fr "$SSH_KEY_PATH"
}

function list_vms(){
    multipass ls
}

# Workaround as sed differs from windows and mac
# so using linux sed in a docker :-)
function docker_sed(){
    local SED_STRING=$1
    local FILE=$2

#    echo "-v "${PWD}/$SSH_KEY_PATH":/keys"
#    echo "-v "${PWD}/$CONFIG_BASE_PATH":/config"
#    echo "-e "$SED_STRING" "
#    echo "$FILE"

     MSYS_NO_PATHCONV=1  docker run --rm \
            -v "${PWD}/$SSH_KEY_PATH":/keys \
            -v "${PWD}/$CONFIG_BASE_PATH":/config \
            hairyhenderson/sed -i \
            -e "$SED_STRING" \
            "$FILE"
}

# Workaround for Path Limitations in Windows 
#function _docker(){
#    MSYS_NO_PATHCONV=1 docker "$@"
#}


# Workaround for Path Limitations in Windows
function _docker() {
  export MSYS_NO_PATHCONV=1
  export MSYS2_ARG_CONV_EXCL='*' 

  case "$OSTYPE" in
      *msys*|*cygwin*) os="$(uname -o)" ;;
      *) os="$(uname)";;
  esac

  if [[ "$os" == "Msys" ]] || [[ "$os" == "Cygwin" ]]; then
      realdocker="$(which -a docker | grep -v "$(readlink -f "$0")" | head -1)"
      printf "%s\0" "$@" > /tmp/args.txt
      # --tty or -t requires winpty
      if grep -ZE '^--tty|^-[^-].*t|^-t.*' /tmp/args.txt; then
          exec winpty /bin/bash -c "xargs -0a /tmp/args.txt '$realdocker'"
          return 0
      fi
  fi
  #exec docker "$@"
  docker "$@"
  return 0
}

function run_main(){
    _docker
    docker_sed

    create_directory_if_not_exists
    generate_ssh_key
    create_cloud_init_config_from_template
    start_ssh_agent_add_public_key
    ssh_config_agent_on_host
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