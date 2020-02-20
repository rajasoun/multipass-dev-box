#!/usr/bin/env ./test/libs/bats/bin/bats

load 'init_unit_test'

setup() {
    echo "SetUp"
}

teardown() {
  echo "teardown"
}

@test ".unit.provision - test provision vm (Stub provision) " {
    init_unit_test
    IP="192.168.64.9"
    ## Subbing provision
    function provision(){
        echo "VM Creation Sucessfull"
        echo "VM Name : $VM_NAME |  IP: $IP "
        echo "Next: SSH to $VM_NAME via Multipass or Bastion Host"
    }
    export -f provision
    run provision
    assert_success
    assert_output -p  "VM Creation Sucessfull"
    assert_output -p  "VM Name : $VM_NAME |  IP: $IP "
    assert_output -p  "Next: SSH to $VM_NAME via Multipass or Bastion Host"
}

@test ".unit.destroy - test destroy vm (Stub destroy) " {
    init_unit_test
    ## Subbing provision
    function destroy(){
        echo "Workspace files cleared"
        echo "$VM_NAME Destroyed"
    }
    export -f destroy
    run destroy
    assert_success
    assert_output -p  "Workspace files cleared"
    assert_output -p  "$VM_NAME Destroyed"
}

@test ".unit.list_vms - test list_vms for zero instances (Stub list_vms) " {
    init_unit_test
    ## Subbing provision
    function list_vms(){
        echo "No instances found"
    }
    export -f list_vms
    run list_vms
    assert_success
    assert_output -p  "No instances found"
}

@test ".unit.list_vms - test list_vms for one instances (Stub list_vms) " {
    init_unit_test
    ## Subbing provision
    function list_vms(){
       echo "$VM_NAME              Running"
    }
    export -f list_vms
    run list_vms
    assert_success
    assert_output -p  "$VM_NAME"
    assert_output -p  "Running"
}

