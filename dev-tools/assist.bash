#!/usr/bin/env bash

set -eo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=src/load.bash
source "$SCRIPT_DIR/src/load.bash"

function help(){
    echo "Usage: $0  {sandbox|git|docker|env-get|env-put}" >&2
    echo
    echo "   sandbox               Manage dev-tools sandbox environment"
    echo "   multipass             Manage multipass - virtualization orchestrator"
    echo "   git                   House Keep Git"
    echo "   docker                House Keep Docker"
    echo "   env-get               Get Variables from AWS parameter store and store it in oidc.env file"
    echo "   env-put               Put Variables and values to AWS parameter store which mentioned in oidc.env"
    echo
    return 1
}


IP="$(get_local_ip)"
TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#COMPOSE_FILES=" -f portainer.yml -f rsyslog.yml -f loki.yml -f grafana.yml -f webtail.yml"
COMPOSE_FILES="  -f $TOOLS_DIR/portainer.yml -f $TOOLS_DIR/rsyslog.yml  -f $TOOLS_DIR/loki.yml -f $TOOLS_DIR/grafana.yml -f $TOOLS_DIR/webtail.yml -f $TOOLS_DIR/traefik.yml -f $TOOLS_DIR/traefik-fa.yml -f $TOOLS_DIR/whoami.yml "
SERVICES=(traefik portainer grafana webtail whoami auth)

export IP
export TOOLS_DIR
export COMPOSE_FILES
export SERVICES

export BASE_DOMAIN=htddev.org
export DOCKER_NETWORK=dev-tools_traefik
#export "$(cat "$TOOLS_DIR"/config/secrets/aws.env)"
#export "$(cat "$TOOLS_DIR"/config/secrets/oidc.env)"
opt="$1"
choice=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
case $choice in
    multipass)
       oidc_exists
      _multipass "$@"
       ;;
    sandbox)
      oidc_exists
      dev_tools_sandbox "$@"
       ;;
    git)       _git "$@" ;;
    docker)
      check_preconditions
      _docker "$@"
      ;;
    env-get)
      aws_get
      ;;
    env-put)
      oidc_exists
      aws_put
      ;;
    *)  help ;;
esac

