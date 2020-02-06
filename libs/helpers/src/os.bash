#!/usr/bin/env bash

# shellcheck source=./libs/helpers/src/log.bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.bash"
# ls, with chmod-like permissions and more.
# @param $1 The directory to ls
function lls() {
  LLS_PATH=$1
  ls -AHl $LLS_PATH | awk "{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/) \
                            *2^(8-i));if(k)printf(\"%0o \",k);print}"
}

# Returns true (0) if this the given command/app is installed and on the PATH or false (1) otherwise.
function os_command_is_installed {
  local -r name="$1"
  command -v "$name" > /dev/null
}