#!/usr/bin/env bash

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

# Usage: ./assist.bash how2 setup workspace for bizapps
# Add Question and Answer in the StackOverflow
function how2(){
  docker run --rm rajasoun/how2 how2 "$@"
}

function help(){
    echo "Usage: $0  {update|clean_submodules|reset_submodules|how2}" >&2
    echo
    echo "   update                  Updates current git branch "
    echo "   clean_submodules        Clean git submodules if they are dirty "
    echo "   reset_submodules        Reset git submodules"
    echo "   how2                    Naturally query stack overflow to get answers"
    echo
    return 1
}

opt="$1"
choice=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
case $choice in
    update)           update ;;
    clean_submodules) clean_submodules ;;
    reset_submodules) reset_submodules ;;
    how2)             how2 "$@" ;;
    *)  help ;;
esac

