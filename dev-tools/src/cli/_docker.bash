#!/usr/bin/env bash

function docker_clean() {
  clean_action="$3"
  case $clean_action in
  volumes)
    echo "Remove Dangling Volumes (not in use by any container)..."
    docker volume rm "$(docker volume ls -q -f "dangling=true")"
    ;;
  containers)
    echo "Remove Exited Containers (not running)..."
    docker rm "$(docker ps -q -f "status=exited")"
    ;;
  images)
    echo "Remove Dangling Images (untagged images)..."
    docker rmi "$(docker images -q -f "dangling=true")"
    ;;
  *)
    echo "assist clean (volumes | containers | images )"
    ;;
  esac
}

function _docker() {
  action="$2"
  case $action in
  prune)
    echo "Clean Everything ..."
    docker system prune -a
    ;;
  status)
    echo "Running Containers ..."
    docker ps --format "table {{.Names}} \t {{.Status}}"
    ;;
  clean)
    docker_clean "$@"
    ;;
  *)
    cat <<-EOF
sandbox commands:
----------------
  prune                                      -> Clean everything
  status                                     -> List running containers
  clean  (volumes | containers | images )    -> Clean Dangling Volumes, Exited Containers & Dangling Images
EOF
    ;;
  esac
}