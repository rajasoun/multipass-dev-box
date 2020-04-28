#!/usr/bin/env sh

MYDIR="$(dirname "$(which "$0")")"

validate_repos(){

if [[ -d "$WORKSPACE" ]] && [[ $PWD/ = $WORKSPACE/* ]]
then
     branchname=`cd $WORKSPACE && git branch | sed -n -e 's/^\* \(.*\)/\1/p'`
    echo " "
    echo "Branch name for" `basename $WORKSPACE : "$branchname"`
else
   echo "Error: $WORKSPACE directory not exists or not in right path"
   exit 1
fi

if [[ -d "$APP_REPO" ]] && [[ $PWD/ = $WORKSPACE/* ]]
then
    branchname=`cd $APP_REPO && git branch | sed -n -e 's/^\* \(.*\)/\1/p'`
     echo " "
     echo "Branch name for" `basename $APP_REPO : "$branchname"`
     echo " "
else
   echo "Error: $APP_REPO directory not exists or not in right path"
   exit 1
fi

}
update_files()
{
mkdir -p $WORKSPACE/logs
clean_files

sed -e "s/APPLICATION_NAME/$APPLICATION_NAME/g ; s/VM_NAME/$VM_NAME/g " $SCRIPTS_PROVISION_TMPL > $SCRIPTS_PROVISION

echo "Configuration files updated with below details"
echo "  "
echo "Application name : $APPLICATION_NAME"
echo "VM_NAME          : $VM_NAME "
echo " "
}

changeperm(){
        chmod +x $APP_SCRIPTS/$APPLICATION_NAME.sh
}

clean_files(){

        rm -f $APP_SCRIPTS/*.sh

}

cmd_exists(){
 [[ "$(command -v $1 )" ]] || { echo "$1 is not installed.Please install $1 and start again." 1>&2 ; exit 1; }

}

confirm_aws_profile() {

msg_fail(){
  echo " $1 aws profile in ~/.aws/credentials or ~/.aws/config not configured."
  exit 1
}

[[ $(aws configure --profile $1 list) && $? -eq 0 ]] && echo "AWS profile $1 Exists" || msg_fail $1
echo " "
}

update_shell_rmt(){
  [ -z "$RMT_MYSQL_DB_PASSWORD" ] && { echo "RMT_MYSQL_DB_PASSWORD value not set, Please verify AWS parameter store is added this value. ";exit 1; }
  sed "s/RMT_MYSQL_DB_PASSWORD/$RMT_MYSQL_DB_PASSWORD/g" ${APP_SCRIPTS}/$APPLICATION_NAME.sh.tmpl > ${APP_SCRIPTS}/$APPLICATION_NAME.sh
}
update_shell_leads(){
  [ -z "$LEADS_MYSQL_DB_PASSWORD" ] && { echo "LEADS_MYSQL_DB_PASSWORD value not set, Please verify AWS parameter store is added this value. ";exit 1; }
  sed "s/LEADS_MYSQL_DB_PASSWORD/$LEADS_MYSQL_DB_PASSWORD/g" ${APP_SCRIPTS}/$APPLICATION_NAME.sh.tmpl > ${APP_SCRIPTS}/$APPLICATION_NAME.sh
}

update_shell_salesinsights(){
  [ -z "$SALESINSIGHTS_MYSQL_DB_PASSWORD" ] && { echo "SALESINSIGHTS_MYSQL_DB_PASSWORD value not set, Please verify AWS parameter store is added this value. ";exit 1; }
  sed "s/SALESINSIGHTS_MYSQL_DB_PASSWORD/$SALESINSIGHTS_MYSQL_DB_PASSWORD/g" ${APP_SCRIPTS}/$APPLICATION_NAME.sh.tmpl > ${APP_SCRIPTS}/$APPLICATION_NAME.sh
}

msg(){
                echo "Usage: $0 {salesinsights|leads|rmt}|{clean} <AWS Profile Name>"
                echo ""
                echo "Use this shell script to update config files with application specific values, Application names you can get it in appinfo.json."
}

check_files(){
  [[ -f ${APP_SCRIPTS}/$APPLICATION_NAME.sh.tmpl ]] || { echo "${APP_SCRIPTS}/$APPLICATION_NAME.sh.tmpl file does not exist!" ; exit 1; }
}

check_vars(){

  [ -z "$APPLICATION_NAME" ] && { echo "Application name not set, Please check the appinfo.json. ";exit 1; }

}

###################################
# Main Script Logic Starts Here   #
###################################

if [ $# -eq 1 ] && [ "$1" = "clean" ]
then
    source variables.sh
    clean_files
elif [[ $# -eq 2 ]]
then
   case "$1" in
        salesinsights|leads|rmt)
                source "$MYDIR"/variables.sh $1 $2
                validate_repos
                check_files
                cmd_exists aws
                cmd_exists multipass
                confirm_aws_profile $2
                check_vars
                update_files
                update_shell_$1 $1
                changeperm
                ;;

        clean)
                source "$MYDIR"/variables.sh
                clean_files
                ;;
        *)
                msg
                ;;
   esac
else
   msg
fi



