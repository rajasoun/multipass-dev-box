#!/usr/bin/env sh

WORKSPACE=${HOME}/workspace/bizapps/htd/multipass-dev-box

APP_CODE=/bizapps/leads
doc_up(){
echo "**************************************Updating apt update  *******************************"
apt-get update -y
echo "**************************************Installing docker  *******************************"
apt install -y docker.io
echo "**************************************Installing docker-compose *******************************"
sudo apt install -y docker-compose
echo "**************************************Starting Config changes *******************************"

echo MYSQL_DATABASE="thordbdev" > $APP_CODE/.env
echo MYSQL_ROOT_PASSWORD="password" >> $APP_CODE/.env
echo MYSQL_ROOT_HOST=% >> $APP_CODE/.env
echo UI_SERVICE_ARGS="-Dspring.profiles.active=dev,common"	>> $APP_CODE/.env
echo API_SERVICE_ARGS="-Dspring.profiles.active=dev"	>> $APP_CODE/.env


echo "**************************************Starting docker-compose up *******************************"
cd $APP_CODE && sudo docker-compose build && sudo docker-compose up -d
echo "************************************** Software and application deployment done *******************************"
echo "PRE_APP_CODE=$APP_CODE" >/tmp/preapp.sh
}

doc_down(){
echo "**************************************   Starting docker-compose down  *******************************"
[[ -f ${APP_CODE}/docker-compose.yaml ]] && { cd $APP_CODE && sudo docker-compose down } || echo "${APP_CODE}/docker-compose.yaml file does not exist!"

#[ -f /etc/resolv.conf ] && echo "$FILE exist" || echo "$FILE does not exist"

pre_app(){

. /tmp/preapp.sh

echo "$PRE_APP_CODE"

if [ "$APP_CODE" == "$PRE_APP_CODE" ];
then
  echo "previous App and current App both are same"
else
[[ -f ${PRE_APP_CODE}/docker-compose.yaml ]] || { cd $PRE_APP_CODE && sudo docker-compose down ; echo "${PRE_APP_CODE}/docker-compose.yaml file does not exist!" ; }

fi
}

[[ -f /tmp/preapp.sh ]] || { pre_app ; echo "/tmp/preapp.sh file does not exist!" ; }

}


###################################
# Main Script Logic Starts Here   #
###################################

case "$1" in
        down)
                doc_down
                ;;

        up)
                doc_up
                ;;
        *)
                echo "should give either down or up";
                ;;
esac
