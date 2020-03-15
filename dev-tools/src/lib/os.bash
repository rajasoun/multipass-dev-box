#!/usr/bin/env bash

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

# Returns the IP or .
function get_local_ip(){
    case "$OSTYPE" in
        darwin*) IP=$(ifconfig en0 | grep inet | grep -v inet6 | cut -d" " -f2)
                 echo "$IP"
                 return 0
                 ;;
        linux*)  IP=$(hostname -I |  cut -d" " -f1)
                 echo "$IP"
                 return 0
                 ;;
        cygwin* | mingw* | msys*)
                IP=$(netstat -rn | grep -w '0.0.0.0' | awk '{ print $4 }')
                 echo "$IP"
                 return 0
                 ;;
        *)echo "unknown: $OSTYPE"
                 return 1
                 ;;
    esac
}
