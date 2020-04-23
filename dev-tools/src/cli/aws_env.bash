#!/usr/bin/env bash

CUR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


cmd_exists(){
 [[ "$(command -v $1 )" ]] || { echo "$1 is not installed.Please install $1 and start again." 1>&2 ; exit 1; }
}

awsenv_exists(){
[[ -f ${CUR_DIR}/../../config/secrets/aws.env ]] || { echo "${CUR_DIR}/../../config/secrets/aws.env file does not exist!" ; exit 1; }
#export "$(cat ${CUR_DIR}/../../config/secrets/aws.env)"
}

oidc_exists(){
[[ -f ${CUR_DIR}/../../config/secrets/oidc.env ]] || { echo "${CUR_DIR}/../../config/secrets/oidc.env file does not exist! Execute $0 env-get to create oidc.env file" ; exit 1; }
export "$(cat ${CUR_DIR}/../../config/secrets/oidc.env)"
}

oidc_template(){
[[ -f ${CUR_DIR}/../../config/secrets/oidc.env.template ]] || { echo "${CUR_DIR}/../../config/secrets/oidc.env.template file does not exist!" ; exit 1; }
}

variable_check(){
oidc_exists
awsenv_exists
while read -r line; do
    var=`echo $line | cut -d '=' -f1`
    test=$(echo $var)
   if [ -z "$test" ];
    then
        echo 'one or more variables are undefined'
        exit 1
    fi
done < $CUR_DIR/../../config/secrets/oidc.env
echo "You are good to go"
}


function aws_put() {
  cmd_exists aws
 # variable_check

  while read -r line; do
    var=`echo $line | cut -d '=' -f1`
    value=`echo $line | cut -d '=' -f2`
    echo $var : $value
    test=$(echo $value)
   if [ ! -z "$test" ];
    then
        aws ssm put-parameter --name "$var" --value "$value" --type SecureString --overwrite
    fi

done < $CUR_DIR/../../config/secrets/oidc.env
echo "Register the AWS parameter store key values from oidc.env file "
}

function get_para(){
  value=$(aws ssm get-parameter --name "$1" --with-decryption | jq -r ".Parameter.Value")
  echo "$1=$value" >> $CUR_DIR/../../config/secrets/oidc.env
}
function aws_get(){
  cmd_exists aws
  oidc_template
 > $CUR_DIR/../../config/secrets/oidc.env
 while read -r line; do
    var=`echo $line | cut -d '=' -f1`
    get_para $var
 done < $CUR_DIR/../../config/secrets/oidc.env.template
export "$(cat "$CUR_DIR"/../../config/secrets/oidc.env)"
echo "Retrived the AWS parameter store key values to oidc.env file "
}
