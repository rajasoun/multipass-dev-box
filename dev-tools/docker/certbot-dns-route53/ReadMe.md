# Certbot

Wrapper around certbot to generate letsencrypt SSL certs with DNS challenge for route53 

Wrapper around certbot to generate letsencrypt SSL certs with DNS challenge for route53.

Usage:
   wget https://raw.githubusercontent.com/rajasoun/nginx_ssl/master/config/ssl_template
   
   cp config/ssl_template config/ssl

Populate the value in ssl

* EMAIL                    -> Valid Email ID
* BASE_DOMAIN              -> Base Domain that you have the ownership in AWS (example: dev.io)
* SUB_DOMAIN               -> Sub domain that requires SSL certificate (nginx.dev.io)
* AWS_ACCESS_KEY_ID        -> AWS Access Key
* AWS_SECRET_ACCESS_KEY    -> AWS Secret Key
* WORKSPACE                -> Workspace Directory 



  docker run --rm \
      -v "${WORKSPACE}/certs:/etc/letsencrypt" \
      -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
      -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
      -e EMAIL="${EMAIL}" \
      -e DOMAINS="${BASE_DOMAIN},${SUB_DOMAIN}" \
      -e USE_STAGING_SERVER="${USE_STAGING_SERVER}" \
      rajasoun/certbot-dns-route53:latest


On Windows: Use the Wrapper :

https://raw.githubusercontent.com/rajasoun/nginx_ssl/master/src/lib/docker_wrapper.bash

chmod +x docker_wrapper.bash

./docker_wrapper.bash run --rm \
      -v "${WORKSPACE}/certs:/etc/letsencrypt" \
      -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
      -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
      -e EMAIL="${EMAIL}" \
      -e DOMAINS="${BASE_DOMAIN},${SUB_DOMAIN}" \
      -e USE_STAGING_SERVER="${USE_STAGING_SERVER}" \
      rajasoun/certbot-dns-route53:latest

References:
* https://github.com/rajasoun/nginx_ssl