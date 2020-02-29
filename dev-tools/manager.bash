#!/usr/bin/env bash

set -eo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=src/load.bash
source "$SCRIPT_DIR/src/load.bash"

function help(){
    echo "Usage: $0  {sandbox|git|docker}" >&2
    echo
    echo "   sandbox               Manage dev-tools sandbox environment"
    echo "   git                   House Keep Git"
    echo "   docker                House Keep Docker"
    echo
    return 1
}


IP="$(get_local_ip)"
TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export IP
export TOOLS_DIR

opt="$1"
choice=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
case $choice in
    sandbox)        dev_tools_sandbox "$@" ;;
    git)              _git "$@" ;;
    docker)
      check_preconditions
      _docker "$@"
      ;;
    *)  help ;;
esac

