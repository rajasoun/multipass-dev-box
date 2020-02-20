#!/usr/bin/env ./test/libs/bats/bin/bats

load 'init_unit_test'

actions_profile_script="./src/multipass/actions.bash"
workspace_env="workspace.env"
instance_env="instance.env"

setup() {
    echo "SetUp"
}

teardown() {
  echo "teardown"
}

@test ".unit.generate_ssh_key (Mock) - generate keys based on VM_NAME varaible" {
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

@test ".unit.create_ssh_connect_script - Validate SSH Connect Script Generation" {
  echo -e "Yet To Implement"
  unset VM_NAME
  unset IP
  unset SSH_CONNECTY_FILE
  # shellcheck disable=SC2031
  assert_empty "${VM_NAME}"
  assert_empty "${IP}"
  assert_empty "${SSH_CONNECTY_FILE}"

  local VM_NAME="TEST_VM"
  local IP="1.1.1.1"
  local SSH_CONNECT_FILE="$CONFIG_BASE_PATH/${VM_NAME}-ssh-connect.sh"
  local SSH_KEY="id_rsa_${VM_NAME}"
  local SSH_CONFIG="$CONFIG_BASE_PATH/${VM_NAME}-ssh-config"
  function create_ssh_connect_script(){
       echo "$SSH_CONNECT_FILE & $SSH_CONFIG Generated for $VM_NAME that is Provisioned with $IP"
  }
  export -f create_ssh_connect_script
  run create_ssh_connect_script
  # shellcheck disable=SC2031
  assert_output --partial "$SSH_CONNECT_FILE & $SSH_CONFIG Generated for $VM_NAME that is Provisioned with $IP"

}



