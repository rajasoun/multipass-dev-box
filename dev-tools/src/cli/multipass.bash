#!/usr/bin/env bash

function _multipass() {
  action="$2"
  case $action in
  purge)
    echo "Deleting/Purging all Multipass VMs..."
    multipass ls  | grep Running |awk '{print $1}' | xargs multipass delete --purge
    multipass purge
    ;;
  status)
    echo "Querying Multipass VM status..."
    multipass ls
    ;;
  *)
    cat <<-EOF
sandbox commands:
----------------
  purge                 -> delete & purging all Multipass VMs
  status                -> list status of all multipass vms
EOF
    ;;
  esac
}