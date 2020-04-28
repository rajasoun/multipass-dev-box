#!/usr/bin/env sh



MYDIR="$(dirname "$(which "$0")")"

app_vars(){
# Update below Application Name  value (salesinsights or leads or rmt etc , these values we got it from appinfo.json)
##########################################

APP_NAME=$1

###########################################
WORKSPACE=${HOME}/workspace/bizapps/htd/multipass-dev-box

source ${WORKSPACE}/instance.env

APP_SCRIPTS=${WORKSPACE}/app_scripts

SCRIPTS_PROVISION_TMPL=${WORKSPACE}/scripts/provisioner.sh.tmpl
SCRIPTS_PROVISION=${WORKSPACE}/scripts/provisioner.sh


APPLICATION_NAME=`eval "$(echo "cat "$MYDIR"/appinfo.json | jq -r '.$APP_NAME[0].Application'")"`


APP_REPO=${HOME}/workspace/bizapps/htd/${APPLICATION_NAME}

}

aws_parameters(){
  PRJ=$(echo $1 | tr '[:lower:]' '[:upper:]')
  export ${PRJ}_MYSQL_DB_PASSWORD=$(aws ssm get-parameter --name ${PRJ}_MYSQL_DB_PASSWORD --profile $2 --with-decryption | jq -r ".Parameter.Value")
}



###################################
# Main Script Logic Starts Here   #
###################################

case "$1" in
        salesinsights|leads|rmt)
                app_vars $1
                aws_parameters $1 $2

                ;;

        clean)
                app_vars $1
                ;;
        *)
                echo""
                ;;
esac
