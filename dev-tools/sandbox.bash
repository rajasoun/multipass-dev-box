#!/usr/bin/env bash

set -eo pipefail
IFS=$'\n\t'
TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

function enter(){
      case $container_name in
          rsyslog)
              echo "Entering /bin/bash session in the rsyslog container..."
              docker-compose -f "$TOOLS_DIR/rsyslog.yml" exec rsyslog bash
              ;;
          *)
              echo "sandbox enter (ryslog)"
              ;;
      esac
}

function logs() {
        case $container_name in
            rsyslog)
                echo "rsyslog Logs ..."
                docker-compose -f "$TOOLS_DIR/rsyslog.yml"  logs -f
                ;;
            *)
                 echo "sandbox logs (rsyslog)"
                ;;
        esac
}

function sandbox() {
    case $action in
        up)
            echo "Spinning up Docker Images..."
            echo "If this is your first time starting sandbox this might take a minute..."
            docker-compose -f "$TOOLS_DIR/rsyslog.yml" up -d --build
            ;;
        down)
            echo "Stopping sandbox containers..."
            docker-compose -f "$TOOLS_DIR/rsyslog.yml" down -v
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
  enter (rsyslog)    -> enter the specified container
  logs  (rsyslog)    -> stream logs for the specified container
EOF
            ;;
    esac
}

action=$1
container_name=$2

sandbox "$@"