#!/usr/bin/env sh


VMS_NAME=microcloud

APPL_NAME=leads

WORKSPACE=${HOME}/workspace/bizapps/htd/multipass-dev-box
LOGFILE_NAME="$APPL_NAME_install_sw_app_$(date +"%Y_%m_%d_%I_%M_%p").log"


function help(){
    echo "Usage: ./sandbox.bash  {up|down|status|logs}" >&2
    echo
    echo "   up               Provision, Configure, Validate Application Stack"
    echo "   down             Application Stack"
    echo "   status           Displays Status of Application Stack"
    echo "   logs             Application Stack Log Dashboard"
    echo
    return 1
}

function mount_exist(){
    multipass transfer ${WORKSPACE}/app_scripts/$APPL_NAME.sh $VMS_NAME:/tmp
    multipass exec $VMS_NAME -- sh /tmp/$APPL_NAME.sh down
    multipass unmount $VMS_NAME
    multipass exec $VMS_NAME -- sudo rm -rf /bizapps/
   # multipass exec $VMS_NAME -- sudo find /bizapps/ -type d -empty -delete
    multipass mount ${WORKSPACE}/../$APPL_NAME $VMS_NAME:/bizapps/$APPL_NAME

    multipass exec $VMS_NAME -- sh /tmp/$APPL_NAME.sh
}

if [ "$( multipass list | grep -c "$VMS_NAME")" -ne 0 ]
then
    if [[ "$( multipass list | grep -c "$VMS_NAME")" ]] && [[ "$( multipass info "$VMS_NAME" | grep Mounts:)" ]]
    then
     echo "VM exist and mounts exist"
     mount_exist
    else
      echo "unmounted"
    multipass mount ${WORKSPACE}/../$APPL_NAME $VMS_NAME:/bizapps/$APPL_NAME
    multipass transfer ${WORKSPACE}/app_scripts/$APPL_NAME.sh $VMS_NAME:/tmp
    multipass exec $VMS_NAME -- sh /tmp/$APPL_NAME.sh
    fi
else
 echo "$VMS_NAME machine not found"
 help
fi


check_files(){
  [[ -f ${APP_SCRIPTS}/$leads.sh.tmpl ]] || { echo "${APP_SCRIPTS}/$leads.sh.tmpl file does not exist!" ; exit 1; }
}

check_site(){
  if curl -I "http://MAC_IP" 2>&1 | grep -w "200\|302" ; then
    echo "http://MAC_IP is up"
else
    echo "http://MAC_IP is down"
fi
}

check_site >> ${WORKSPACE}/logs/${LOGFILE_NAME}
