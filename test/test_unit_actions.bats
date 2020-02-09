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
  assert_success   
}

@test ".create_directory_if_not_exists For valid Directory Name" {
  source ${actions_profile_script} 
  run create_directory_if_not_exists "${SSH_TEST_KEY_PATH}"
  assert_success   
}

@test ".generate_ssh_key - generate keys based on VM_NAME varaible" {    
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




