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
    echo "${SSH_KEY} & ${SSH_KEY}.pub keys generated successfully"
}

function create_cloud_init_config_from_template() {
    local SSH_KEY="id_rsa_${VM_NAME}"
    local CLOUD_INIT_FILE="$CLOUD_INIT_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    cp "$CLOUD_INIT_TEMPLATE" "$CLOUD_INIT_FILE"

    #@ToDo: Optimize Edits
    docker_sed "s,ssh-rsa.*$,$(cat "$SSH_KEY_PATH"/"${SSH_KEY}".pub),g" "/config/${VM_NAME}-cloud-init.yaml"
    docker_sed  "s,hostname:.*$,hostname:\ $VM_NAME,g" "/config/${VM_NAME}-cloud-init.yaml"

    echo "$CLOUD_INIT_FILE Generated for $VM_NAME"
}

function start_ssh_agent_add_public_key(){
    local SSH_KEY="id_rsa_${VM_NAME}"
    #@FixMe : Creates Problem in Windows
    # Ensure SSH Agent Is Running in Background
    eval "$(ssh-agent -s)"
    SSH_OPTS=$(get_ssh_opts)
    #echo "ssh-add $SSH_OPTS $SSH_KEY_PATH/${SSH_KEY} "
    ssh-add "$SSH_OPTS $SSH_KEY_PATH/${SSH_KEY}"
}

function ssh_config_agent_on_host(){
    IP=$(multipass info "$VM_NAME" | grep IPv4 | awk '{print $2}')
    # delete old key from known_hosts
    docker_sed "/${IP}/d"   /ssh/known_hosts
    # rescan the Host and add it to the known_hosts
    ssh-keyscan -t rsa "$IP" >> ~/.ssh/known_hosts

    # updating local ssh configuration.
    echo -e "Host $VM_NAME\n\tHostname ${IP}\n\tUser ubuntu\n\tIdentityFile $SSH_KEY_PATH/id_rsa_$VM_NAME\n" > "$SSH_CONFIG"
    echo "SSH Agent Configured Successfully"
    echo "Next: ssh -F $SSH_CONFIG $VM_NAME or ssh -i keys/multipass/id_rsa_$VM_NAME ubuntu@$IP"
    start_ssh_agent_add_public_key
}


function provision(){
    check_required_workspace_env_vars
    check_required_instance_env_vars

    create_directory_if_not_exists "$SSH_KEY_PATH"
    generate_ssh_key
    create_cloud_init_config_from_template "$VM_NAME"

    local CLOUD_INIT_FILE="$CLOUD_INIT_BASE_PATH/${VM_NAME}-cloud-init.yaml"
    ## Exit if Launch Fails
    multipass launch -c"$CPU" -m"$MEMORY" -d"$DISK" -n "$VM_NAME" lts --cloud-init "$CLOUD_INIT_FILE" || exit
    IP=$(multipass info "$VM_NAME" | grep IPv4 | awk '{print $2}')

    echo "VM Creation Sucessfull"
    echo "VM Name : $VM_NAME |  IP: $IP "
    echo "Next: SSH to $VM_NAME through Nuktipass or Configure Host to do SSH"
}

function destroy(){
    IP=$(multipass info "$VM_NAME" | grep IPv4 | awk '{print $2}')
    # delete old key from known_hosts
    # ~/.ssh of host mounted on /ssh in docker
    docker_sed "/${IP}/d" /ssh/known_hosts

    multipass delete "$VM_NAME" && multipass purge
    rm -fr "$CLOUD_INIT_FILE"
    rm -fr "$SSH_KEY_PATH"
}

function clear_workspace(){
    rm -fr "$CLOUD_INIT_FILE"
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
#    echo "-v "${PWD}/$CLOUD_INIT_BASE_PATH":/config"
#    echo "-e "$SED_STRING" "
#    echo "$FILE"

    _docker run --rm \
            -v "${PWD}/$SSH_KEY_PATH":/keys \
            -v "${PWD}/$CLOUD_INIT_BASE_PATH":/config \
            hairyhenderson/sed -i \
            -e "$SED_STRING" \
            "$FILE"
}

# Workaround for ssh on Windows 
function get_ssh_opts(){
    case "$OSTYPE" in
        msys* | cygwin* | linux*) echo "-k" ;;
        darwin*) echo "-K"  ;;
        *) echo "unknown: $OSTYPE";exit  ;;
    esac 
}

# Workaround for Path Limitations in Windows 
function _docker(){
    MSYS_NO_PATHCONV=1 docker "$@"
}

function run_main(){
    get_ssh_opts
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
  run_main
  # shellcheck disable=SC2181
  if [ $? -gt 0 ]
  then
    exit 1
  fi
fi