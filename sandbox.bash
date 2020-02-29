#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=dev-tools/src/load.bash
source "$SCRIPT_DIR/dev-tools/src/load.bash"

# Usage: ./assist.bash how2 setup workspace for bizapps
# Add Question and Answer in the StackOverflow
function how2(){
  docker run --rm rajasoun/how2 how2 "$@"
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

opt="$1"
choice=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
case $choice in
    up) echo "UP TBD" ;;
    down)echo "DOWN TBD" ;;
    status)echo "STATUS TBD" ;;
    logs)echo "LOGS TBD" ;;
    *)  help ;;
esac