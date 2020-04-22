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

function reset_submodules(){
  git submodule deinit -f .
  git submodule update --init --recursive --remote
}

function clean_submodules(){
  git submodule foreach --recursive 'git reset HEAD . || :'
  git submodule foreach --recursive 'git checkout -- . || :'
  git submodule update --init --recursive
  git submodule foreach --recursive git clean -d -f -f -x
}

function update() {
  changed=0
  git remote update && git status -uno | grep -q 'Your branch is behind' && changed=1
  if [ $changed = 1 ]; then
     echo "Remote Has Changed"
     clean_submodules
     git pull
     echo "Updated successfully";
  else
    echo "Up-to-date"
  fi
}

function _git() {
  action="$2"
  case $action in
  update)
    echo "Git Check Remote Branch & Update ..."
    update
    ;;
  clean_submodules)
    echo "Clean Submodules for the Repo ..."
    clean_submodules
    ;;
  reset_submodules)
    reset_submodules
    ;;
  *)
    cat <<-EOF
sandbox commands:
----------------
  update                                     -> Check for updates in Remote Branch and Update
  clean_submodules                           -> Clean Submodules in the repo
  reset_submodules                           -> Reset Submodules In the Repo
EOF
    ;;
  esac
}