#!/usr/bin/env sh

#References:
# https://linuxize.com/post/how-to-set-dns-nameservers-on-ubuntu-18-04/
# https://discourse.ubuntu.com/t/troubleshooting-networking-on-macos/12901
# https://github.com/lucaswhitaker22/bash_menus/blob/master/bash_menus/demo.sh

### Arguments with Default Values
VM_NAME=${1:-"bizapps"}
CPU=${2:-"1"}
MEMORY=${3:-"2G"}
DISK=${4:-"5G"}

SSH_CONFIG="config/ssh-config"
SSH_KEY_PATH="$HOME/.ssh/multipass"
SSH_KEY="id_rsa_${VM_NAME}"
CLOUD_INIT_TEMPLATE="config/cloud-init-template.yaml"
CLOUD_INIT_FILE="config/${VM_NAME}-cloud-init.yaml"

init_ssh_key() {
    ## Create Directory If Not Exists
    if [ ! -d $SSH_KEY_PATH ]; then
      mkdir -p $SSH_KEY_PATH
    fi
    echo -e 'y\n' | ssh-keygen -q -t rsa -C "$(whoami)@bizapps.cisco.com" -N "" \
                    -f $SSH_KEY_PATH/${SSH_KEY} 2>&1 > /dev/null
}

update_cloud_init() {
    cp $CLOUD_INIT_TEMPLATE $CLOUD_INIT_FILE
    sed -i '' "s,ssh-rsa.*$,$(cat $SSH_KEY_PATH/${SSH_KEY}.pub),g" $CLOUD_INIT_FILE
}


ssh_config_agent_on_host(){
    # Ensure SSH Agent Is Running in Background
    eval "$(ssh-agent -s)"
    # Automatically load keys into the ssh-agent
    yes | cp -rf ~/.ssh/config ~/.ssh/config.bak
    cat $SSH_CONFIG > ~/.ssh/config
    # Add your SSH private key to the ssh-agent and store your passphrase in the keychain
    ssh-add -K ~/.ssh/id_rsa
    ssh-add -K ~/.ssh/multipass/id_rsa_$VM_NAME

    IP=$(multipass info $VM_NAME | grep IPv4 | awk '{print $2}')
    # delete old key from known_hosts
    sed -i '' "/${IP}/d" ~/.ssh/known_hosts

    # rescan the Host and add it to the known_hosts
    ssh-keyscan -t rsa $IP >> ~/.ssh/known_hosts
    echo "Host $VM_NAME\n\tHostname ${IP}\n\tUser ubuntu\n\tIdentityFile ~/.ssh/multipass/id_rsa_$VM_NAME" >> ~/.ssh/config
    echo "SSH Agemnt Configured Successfully"
}

setup(){
    init_ssh_key
    update_cloud_init "bizapps"
}


provision(){
    setup
    multipass launch -c$CPU -m$MEMORY -d$DISK -n $VM_NAME lts --cloud-init $CLOUD_INIT_FILE || exit
    IP=$(multipass info $VM_NAME | grep IPv4 | awk '{print $2}')
    ssh_config_agent_on_host    
    echo "$VM_NAME Created with IP: $IP"
    echo "Test: ssh bizapps"
}

destroy(){
    rm -fr $CLOUD_INIT_FILE
    rm -fr $SSH_KEY_PATH
    rm -fr $PWD/.bastion_keys

    # Reset with Defaults
    cat $SSH_CONFIG > ~/.ssh/config
    is_vm_running=$(multipass ls | grep $VM_NAME |awk '{ print $2}' | wc -l )

    if [ $is_vm_running -eq 1 ];then
        multipass delete $VM_NAME && multipass purge
    fi 
}

menu() {
    tput clear
    title=$1
    in=$2
    arr=$(echo $in | tr "," "\n")
    x=1
    y=1
    
    tput cup $y $x
    tput rev;echo " $title "; tput sgr0
    x=$((x+${#title}+4))
    i=0
    for n in $arr
    do
        tput cup $(( y+$i )) $x
            str="$n" 
            echo "$((i+1)). $str"
        i=$((i+1))
    done
    tput cup $(( y+$i+1 )) $((x-$((${#title}+4))))
    read -p "Enter your choice [1-$i] " choice
    return $choice
}

help(){
    menu "Multipass Manager" "Provision,SSH,Destroy"
    choice=$?
    case $choice in 
        1) 
            provision 
            ;;
        2) 
            ssh bizapps
            ;;
        3) destroy
            ;;
        *) 
            echo "Invalid Input"
            ;;
    esac
}
help





