#!/usr/bin/env ./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

actions_profile_script="./src/multipass/actions.bash"
workspace_env="workspace.env"
instance_env="instance.env"

setup() {
    echo "SetUp"
}

teardown() {
  echo "teardown"
}

@test ".create_directory_if_not_exists For Empty Directory Name" {
  source ${actions_profile_script} 
  run create_directory_if_not_exists ""
  assert_failure
}

@test ".generate_ssh_key (Mock) - generate keys based on VM_NAME varaible" {    
    source ${instance_env}
    source ${workspace_env}
    unset VM_NAME
    assert_empty "${VM_NAME}"
    VM_NAME="TEST_VM"
    function generate_ssh_key() { ##Mock To Validate Varibale substitution
        local SSH_KEY="id_rsa_${VM_NAME}"
        echo "${SSH_KEY} & ${SSH_KEY}.pub keys generated successfully"
    }
    export -f generate_ssh_key
    run generate_ssh_key
    assert_output --partial "id_rsa_$VM_NAME & id_rsa_$VM_NAME.pub keys generated"
}

@test ".update_cloud_init_template (Mock) - generate Cloud Init File based on VM_NAME varaible" {    
    source ${instance_env}
    source ${workspace_env}
    unset VM_NAME
    assert_empty "${VM_NAME}"
    VM_NAME="TEST_VM"
    function update_cloud_init_template() { ##Mock To Validate Varibale substitution
        local SSH_KEY="id_rsa_${VM_NAME}"
        local CLOUD_INIT_FILE="config/${VM_NAME}-cloud-init.yaml"
        echo "$CLOUD_INIT_FILE Generated for $VM_NAME"
    }
    export -f update_cloud_init_template
    run update_cloud_init_template
    assert_output --partial "config/$VM_NAME-cloud-init.yaml Generated for $VM_NAME"
}




