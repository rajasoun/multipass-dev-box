#!/usr/bin/env bash

function generate_ssh_key() {
    ## Create Directory If Not Exists
    if [ ! -d $SSH_KEY_PATH ]; then
      mkdir -p $SSH_KEY_PATH
    fi
    echo -e 'y\n' | ssh-keygen -q -t rsa -C \
                            "$(whoami)@bizapps.cisco.com" -N "" \
                            -f $SSH_KEY_PATH/${SSH_KEY} 2>&1 > /dev/null
}

function update_cloud_init_template() {
    cp $CLOUD_INIT_TEMPLATE $CLOUD_INIT_FILE
    docker_sed "s,ssh-rsa.*$,$(cat $SSH_KEY_PATH/${SSH_KEY}.pub),g" \
            /config/${VM_NAME}-cloud-init.yaml
}

function ssh_config_agent_on_host(){
    # Ensure SSH Agent Is Running in Background
    eval "$(ssh-agent -s)"
    SSH_OPTS=$(get_ssh_opts)
    #echo "ssh-add $SSH_OPTS $SSH_KEY_PATH/${SSH_KEY} "
    ssh-add $SSH_OPTS $SSH_KEY_PATH/${SSH_KEY} 

    IP=$(multipass info $VM_NAME | grep IPv4 | awk '{print $2}')
    # delete old key from known_hosts
    docker_sed "/${IP}/d"   /ssh/known_hosts
    # rescan the Host and add it to the known_hosts
    ssh-keyscan -t rsa $IP >> ~/.ssh/known_hosts

    # updating local ssh configuration.
    echo -e "Host $VM_NAME\n\tHostname ${IP}\n\tUser ubuntu\n\tIdentityFile $SSH_KEY_PATH/id_rsa_$VM_NAME\n" > $SSH_CONFIG 
    echo "SSH Agent Configured Successfully"
    echo "Next: ssh -F $SSH_CONFIG $VM_NAME or ssh -i keys/multipass/id_rsa_$VM_NAME ubuntu@$IP"
}


function provision(){
    generate_ssh_key
    update_cloud_init_template $VM_NAME

    multipass launch -c$CPU -m$MEMORY -d$DISK -n $VM_NAME lts --cloud-init $CLOUD_INIT_FILE || exit
   
    IP=$(multipass info $VM_NAME | grep IPv4 | awk '{print $2}')  
    echo "VM Creation Sucessfull"
    echo "VM Name : $VM_NAME |  IP: $IP "
    echo "Next: Select 2 from the Menu to ssh to the $VM_NAME"
}

function destroy(){
    IP=$(multipass info $VM_NAME | grep IPv4 | awk '{print $2}')
    # delete old key from known_hosts
    # ~/.ssh mounted on /ssh in docker
    docker_sed "/${IP}/d" /ssh/known_hosts

    multipass delete $VM_NAME && multipass purge
    rm -fr $CLOUD_INIT_FILE
    rm -fr $SSH_KEY_PATH
    #docker_sed '1,/#start/p;/#end/,$p' $SSH_CONFIG
}

function clear_workspace(){
    rm -fr $CLOUD_INIT_FILE
    rm -fr $SSH_KEY_PATH
}

function list_vms(){
    multipass ls
}

# Workaround as sed differs from windows and mac
# so using linux sed in a docker :-)
function docker_sed(){
    SED_STRING=$1
    FILE=$2
    _docker run --rm \
            -v "${HOME}/.ssh":/ssh \
            -v "${PWD}/keys/multipass":/keys \
            -v "${PWD}/config":/config \
            hairyhenderson/sed -i \
            -e "$SED_STRING" \
            $FILE
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