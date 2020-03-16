#!/usr/bin/env bash

set -eo pipefail
TIMING_LOG_FILE="dev-tools/logs/sandbox_execution.log"
LOCAL_DEBUG_LOG_FILE="dev-tools/logs/local_debug.log"

function include(){
    if [[ -f "dev.$1" ]]; then
        # shellcheck disable=SC1090
        source "dev.$1"  #source from custom env file if present
    else
        # shellcheck disable=SC1090
        source "$1" #source from deafult env file
    fi
    # shellcheck source=$pwd/src/load
    source "src/load.bash"
}

function help(){
    echo "Usage: $0  {up|down|status|logs}" >&2
    echo
    echo "   up               Provision, Configure, Validate Application Stack"
    echo "   down             Application Stack"
    echo "   status           Displays Status of Application Stack"
    echo "   logs             Application Stack Log Dashboard"
    echo
    return 1
}

function execute_api_action(){
    start=$(date +%s)
    vm_api_execute_action "$1" >> "$LOCAL_DEBUG_LOG_FILE" || return 1
    end=$(date +%s)
    runtime=$((end-start))
     >&2  echo -e "$(date +"%Y-%m-%d %H:%M:%S") | $1 | $(display_time $runtime)" >> "$TIMING_LOG_FILE"
}

include "instance.env"
MODE="api"
export MODE

opt="$1"
choice=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
case $choice in
    up)
      echo "Bring Up Application Stack"
      echo "Local Debug Logs available at Web Tail"
      echo "GoTo: https://webtail.htddev.org"
      execute_api_action "provision_vm"
      execute_api_action "configure_vm_from_bastion"
      execute_api_action "test_infra"
      execute_api_action "list_all_vms"
      ;;
    down)
      echo "Destroy Application Stack & Services"
      execute_api_action "destroy_vm"
      ;;
    status)
      echo "Application Stack and Services Status available at @Observability Dashboard"
      echo "TBD : StatPing"
      dev-tools/assist.bash sandbox status
      ;;
    logs)
      echo "Application Logs available at @Observability Dashboard"
      echo "GoTo: Log Aggregator -> https://grafana.httddev.org/explore"
      ;;
    *)  help ;;
esac