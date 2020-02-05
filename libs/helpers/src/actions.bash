#!/usr/bin/env bash

function generate_ssh_key() {
    ## Create Directory If Not Exists
    if [ ! -d $SSH_KEY_PATH ]; then
      mkdir -p $SSH_KEY_PATH
    fi
    echo -e 'y\n' | ssh-keygen -q -t rsa -C "$(whoami)@bizapps.cisco.com" -N "" \
                    -f $SSH_KEY_PATH/${SSH_KEY} 2>&1 > /dev/null
}

function update_cloud_init_template() {
    cp $CLOUD_INIT_TEMPLATE $CLOUD_INIT_FILE
    sed -i '' "s,ssh-rsa.*$,$(cat $SSH_KEY_PATH/${SSH_KEY}.pub),g" $CLOUD_INIT_FILE
}


function ssh_config_agent_on_host(){
    # Ensure SSH Agent Is Running in Background
    eval "$(ssh-agent -s)"
    # Automatically load keys into the ssh-agent
    yes | cp -rf ~/.ssh/config ~/.ssh/config.bak
    cat $SSH_CONFIG > ~/.ssh/config
    # Add your SSH private key to the ssh-agent and store your passphrase in the keychain
    #ssh-add -k ~/.ssh/id_rsa
    ssh-add -k ~/.ssh/multipass/id_rsa_$VM_NAME

    IP=$(multipass info $VM_NAME | grep IPv4 | awk '{print $2}')
    # delete old key from known_hosts
    sed -i '' "/${IP}/d" ~/.ssh/known_hosts

    # rescan the Host and add it to the known_hosts
    ssh-keyscan -t rsa $IP >> ~/.ssh/known_hosts
    echo "\nHost $VM_NAME\n\tHostname ${IP}\n\tUser ubuntu\n\tIdentityFile ~/.ssh/multipass/id_rsa_$VM_NAME" >> ~/.ssh/config
    echo "SSH Agemnt Configured Successfully"
    echo "Next: ssh $VM_NAME or ssh $VM_NAME@$IP"
}


function provision(){
    generate_ssh_key
    update_cloud_init_template $VM_NAME
    multipass launch -c$CPU -m$MEMORY -d$DISK -n $VM_NAME lts --cloud-init $CLOUD_INIT_FILE || exit
    IP=$(multipass info $VM_NAME | grep IPv4 | awk '{print $2}')  
    echo "$VM_NAME Created with IP: $IP"
    echo "Next: Select 2 from the Menu to ssh to the $VM_NAME"
}

function destroy(){
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

function menu() {
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

function comment_line(){
    pattern=$1
    file_to_edit=$2
    sed -i '' -e "/$pattern/ s/^#*/#/g"  file_to_edit
}

function uncomment_line(){
    pattern=$1
    file_to_edit=$2
    sed -i '' -e "/$pattern/s/^#//g"  file_to_edit
}

sed -i '/<pattern>/s/^#//g' file #uncomment