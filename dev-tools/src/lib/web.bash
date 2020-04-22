#!/usr/bin/env bash

function display_url_status(){
    HOST="$1"
    # shellcheck disable=SC1083
    if [[ "$(curl -s -o /dev/null -L -w ''%{http_code}'' "${HOST}")" != "200" ]] ; then
        echo "https://${HOST}  -> Down"
    else
        echo "https://${HOST}  -> Up"
    fi
}


function display_app_status(){
    echo "Apps Status"
    execute_action "display_url_status"
}
