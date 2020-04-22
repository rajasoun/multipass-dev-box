#!/usr/bin/env bash

# Path to your hosts file
hostsFile="/etc/hosts"

# Default IP address for host
ip="127.0.0.1"

yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "cannot $*"; }


# ToDo: Specific To Linux & Mac -> To Be Ported for Windows
function remove_entry() {
    hostname=$1
    # shellcheck disable=SC2143
    if [ -n "$(grep  "[[:space:]]$hostname" /etc/hosts)" ]; then
        echo "$hostname found in $hostsFile. Removing now...";
        try sudo sed -ie "/[[:space:]]$hostname/d" "$hostsFile";
    else
        yell "$hostname was not found in $hostsFile";
    fi
}

# ToDo: Specific To Linux & Mac -> To Be Ported for Windows
function add_entry() {
    hostname=$1
    if [ -n "$(grep  "[[:space:]]$hostname" /etc/hosts)" ]; then
        yell "$hostname, already exists: $(grep $hostname $hostsFile)";
    else
        echo "Adding $hostname to $hostsFile...";
        try printf "%s\t%s\n" "$ip" "$hostname" | sudo tee -a "$hostsFile" > /dev/null;

        if [ -n "$(grep $hostname /etc/hosts)" ]; then
            echo "$hostname was added succesfully:";
            #echo "$(grep $hostname /etc/hosts)";
        else
            die "Failed to add $hostname";
        fi
    fi
}

# ToDo: Specific To Linux & Mac -> To Be Ported for Windows
function backup_etc_hosts(){
    try sudo cp "$hostsFile" "$hostsFile.bak"
}

function add_host_entries(){
  execute_action "add_entry"
}

function remove_host_entries(){
  backup_etc_hosts
  execute_action "remove_entry"
}