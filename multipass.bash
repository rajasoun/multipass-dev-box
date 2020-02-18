#!/usr/bin/env bash

#References:
# https://linuxize.com/post/how-to-set-dns-nameservers-on-ubuntu-18-04/
# https://discourse.ubuntu.com/t/troubleshooting-networking-on-macos/12901
# https://github.com/lucaswhitaker22/bash_menus/blob/master/bash_menus/demo.sh

function include(){
    if [[ -f "dev.$1" ]]; then
        # shellcheck disable=SC1090
        source "dev.$1"  #source from custom env file if present
    else
        # shellcheck disable=SC1090
        source "$1" #source from deafult env file
    fi
    # shellcheck source=$pwd/src/load
    source "$WORKSPACE/src/load"
}

include "instance.env"
echo "$MENU"
case "$MENU" in
    *help*) choose_action_from_help ;;
     *api*)  execute_action "$1";;
         *) choose_action_from_menu ;;
esac






