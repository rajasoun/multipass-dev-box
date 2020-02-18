#!/usr/bin/env bash

# Workaround as sed differs from windows and mac
# so using linux sed in a docker :-)
# @Deprecated: Not In useß
function docker_sed(){
    local SED_STRING=$1
    local FILE=$2

     MSYS_NO_PATHCONV=1  docker run --rm \
            -v "${PWD}/$SSH_KEY_PATH":/keys \
            -v "${PWD}/$CONFIG_BASE_PATH":/config \
            hairyhenderson/sed -i \
            -e "$SED_STRING" \
            "$FILE"
}

# Workaround for Path Limitations in Windows
function _docker() {
  export MSYS_NO_PATHCONV=1
  export MSYS2_ARG_CONV_EXCL='*'

  case "$OSTYPE" in
      *msys*|*cygwin*) os="$(uname -o)" ;;
      *) os="$(uname)";;
  esac

  if [[ "$os" == "Msys" ]] || [[ "$os" == "Cygwin" ]]; then
      # shellcheck disable=SC2230
      realdocker="$(which -a docker | grep -v "$(readlink -f "$0")" | head -1)"
      printf "%s\0" "$@" > /tmp/args.txt
      # --tty or -t requires winpty
      if grep -ZE '^--tty|^-[^-].*t|^-t.*' /tmp/args.txt; then
          #exec winpty /bin/bash -c "xargs -0a /tmp/args.txt '$realdocker'"
          winpty /bin/bash -c "xargs -0a /tmp/args.txt '$realdocker'"
          return 0
      fi
  fi
  docker "$@"
  return 0
}

function run_main(){
  docker_sed "$@"
  _docker "$@"

}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! run_main "$@"
  then
    exit 1
  fi
fi