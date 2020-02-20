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

@test ".unit.create_cloud_init_config_from_template (Mock) - generate Cloud Init File based on VM_NAME varaible" {
    source ${instance_env}
    source ${workspace_env}
    unset VM_NAME
    # shellcheck disable=SC2031
    assert_empty "${VM_NAME}"
    # shellcheck disable=SC2030
    VM_NAME="TEST_VM"
    function create_cloud_init_config_from_template() { ##Mock To Validate Varibale substitution
        local SSH_KEY="id_rsa_${VM_NAME}"
        local CLOUD_INIT_FILE="config/${VM_NAME}-cloud-init.yaml"
        echo "$CLOUD_INIT_FILE Generated for $VM_NAME"
    }
    export -f create_cloud_init_config_from_template
    run create_cloud_init_config_from_template
    assert_output --partial "config/$VM_NAME-cloud-init.yaml Generated for $VM_NAME"
}



