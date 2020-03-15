#!/usr/bin/env bash

set -eo pipefail

function enter() {
  container_name="$3"
  case $container_name in
  rsyslog)
    echo "Entering /bin/bash session in the rsyslog container..."
    docker-compose -f "$TOOLS_DIR/rsyslog.yml" exec rsyslog bash
    ;;
  *)
    echo "sandbox enter (ryslog )"
    ;;
  esac
}

function logs() {
  container_name="$3"
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
    echo "sandbox logs (rsyslog | portainer )"
    ;;
  esac
}

function send_msg_to_syslog(){
  docker run --rm --log-driver syslog --log-opt syslog-address=udp://"$IP":5514 alpine echo "$@"
}

function dev_tools_sandbox() {
  action="$2"
  case $action in
  up)
    echo "Spinning up Docker Images..."
    echo "If this is your first time starting sandbox this might take a minute..."
    eval docker-compose  "${COMPOSE_FILES}" up -d --build
    add_host_entries
    ;;
  send_msg)
    send_msg_to_syslog "$@"
    ;;
  down)
    echo "Stopping sandbox containers..."
    eval docker-compose   "${COMPOSE_FILES}" down -v  --remove-orphans
    remove_host_entries
    docker container prune -f
    echo "Removing file $TOOLS_DIR/logs/syslog ..."
    rm -fr "$TOOLS_DIR/logs/syslog"
    echo "Removing file $TOOLS_DIR/logs/local_debug.log ..."
    rm -fr "$TOOLS_DIR/logs/local_debug.log"
    ;;
  status)
    echo "Querying sandbox containers status..."
    display_app_status
    eval docker-compose "${COMPOSE_FILES}"  ps
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
  status             -> displays status of  services
  send_msg           -> sends message to syslog
  enter (rsyslog | portainer)    -> enter the specified container
  logs  (rsyslog | portainer)    -> stream logs for the specified container
EOF
    ;;
  esac
}