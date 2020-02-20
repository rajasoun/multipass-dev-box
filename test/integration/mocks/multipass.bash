#!/usr/bin/env bash

## For Info
function hash_caf9b6b99962bf5c2264824231d7a40c {
    echo "Name:           $VM_NAME
State:          Running
IPv4:           192.168.64.19
Release:        Ubuntu 18.04.4 LTS
Image hash:     3c3a67a14257 (Ubuntu 18.04 LTS)
Load:           0.00 0.02 0.02
Disk usage:     1000.3M out of 4.7G
Memory usage:   72.5M out of 985.7M"
    exit 0
}

### For Launch
function hash_e655785894fde4dcd1c610d0a722e5bc {
    echo "
Creating $VM_NAME 
Configuring $VM_NAME 
Starting $VM_NAME
Waiting for initialization to complete
Launched: $VM_NAME"
    exit 0
}

## list
function hash_10ae9fc7d453b0dd525d0edf2ede7961 {
    echo "
Name         State             IPv4             Image
$VM_NAME     Running           192.168.64.19    Ubuntu 18.04 LTS"
    exit 0
}

## ls
function hash_44ba5ca65651b4f36f1927576dd35436 {
    echo "
Name         State             IPv4             Image
$VM_NAME     Running           192.168.64.19    Ubuntu 18.04 LTS"
    exit 0
}

## destroy
function hash_099af53f601532dbd31e0ea99ffdeb64 {
    exit 0
}

## purge
function hash_c1576b545a2eaca25de49f6112298166 {
    exit 0
}

funame=hash_$(echo -n "$1" | md5sum | cut -d" " -f1)
if ! type "${funame}" > /dev/null 2>&1; then
    >&2 echo "ERROR: $0 $* is not mocked"
    exit 1
fi
$funame