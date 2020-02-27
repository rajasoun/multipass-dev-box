#!/usr/bin/env bash

set -eo pipefail
IFS=$'\n\t'
TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090
source "$(dirname "${BASH_SOURCE[0]}")/../src/multipass/os.bash"

function check_preconditions() {
  if ! [ -x "$(command -v docker)" ]; then
    echo 'Error: docker is not installed.' >&2
    exit 1
  fi

  if ! [ -x "$(command -v docker-compose)" ]; then
    echo 'Error: docker-compose is not installed.' >&2
    exit 1
  fi
}

function enter() {
  case $container_name in
  rsyslog)
    echo "Entering /bin/bash session in the rsyslog container..."
    docker-compose -f "$TOOLS_DIR/rsyslog.yml" exec rsyslog bash
    ;;
  *)
    echo "sandbox enter (ryslog | grafana)"
    ;;
  esac
}

function logs() {
  case $container_name in
  rsyslog)
    echo "rsyslog Logs ..."
    docker-compose -f "$TOOLS_DIR/rsyslog.yml" logs -f
    ;;
  portainer)
    echo "portainer Logs ..."
    docker-compose -f "$TOOLS_DIR/portainer.yml" logs -f
    ;;
  *)
    echo "sandbox logs (rsyslog | portainer | grafana)"
    ;;
  esac
}

function send_msg_to_syslog(){
  docker run --rm --log-driver syslog --log-opt syslog-address=udp://$(get_local_ip):5514 alpine echo "$@"
}

function sandbox() {
  case $action in
  up)
    echo "Spinning up Docker Images..."
    echo "If this is your first time starting sandbox this might take a minute..."
    docker-compose  -f "$TOOLS_DIR/portainer.yml" -f "$TOOLS_DIR/rsyslog.yml" \
                    -f "$TOOLS_DIR/loki.yml" -f "$TOOLS_DIR/grafana.yml" up -d --build
    ;;
  send_msg)
    send_msg_to_syslog "$@"
    ;;
  down)
    echo "Stopping sandbox containers..."
    docker-compose  -f "$TOOLS_DIR/portainer.yml" -f "$TOOLS_DIR/rsyslog.yml" \
                    -f "$TOOLS_DIR/loki.yml" -f "$TOOLS_DIR/grafana.yml" \
                    down -v  --remove-orphans
    docker container prune -f
    echo "Removing file $TOOLS_DIR/logs/syslog ..."
    rm -fr "$TOOLS_DIR/logs/syslog"
    ;;
  enter)
    enter "$@"
    ;;
  logs)
    logs "$@"
    ;;
  *)
    cat <<-EOF
sandbox commands:
----------------
  up                 -> spin up the dev-tools sandbox environment
  down               -> tear down the dev-tools sandbox environment
  send_msg           -> sends message to syslog
  enter (rsyslog | portainer)    -> enter the specified container
  logs  (rsyslog | portainer)    -> stream logs for the specified container
EOF
    ;;
  esac
}

action=$1
container_name=$2

check_preconditions
sandbox "$@"
