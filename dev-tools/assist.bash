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
    echo "   multipass             Manage multipass - virtualization orchestrator"
    echo "   git                   House Keep Git"
    echo "   docker                House Keep Docker"
    echo
    return 1
}


IP="$(get_local_ip)"
TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#COMPOSE_FILES=" -f portainer.yml -f rsyslog.yml -f loki.yml -f grafana.yml -f webtail.yml"
COMPOSE_FILES="  -f $TOOLS_DIR/portainer.yml -f $TOOLS_DIR/rsyslog.yml  -f $TOOLS_DIR/loki.yml -f $TOOLS_DIR/grafana.yml -f $TOOLS_DIR/webtail.yml"
SERVICES=(portainer grafana webtail)

export IP
export TOOLS_DIR
export COMPOSE_FILES
export SERVICES

export BASE_DOMAIN=htddev.org
#export $(cat config/ssl)
#export $(cat config/sso)



opt="$1"
choice=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
case $choice in
    multipass) _multipass "$@" ;;
    sandbox)   dev_tools_sandbox "$@" ;;
    git)       _git "$@" ;;
    docker)
      check_preconditions
      _docker "$@"
      ;;
    *)  help ;;
esac

