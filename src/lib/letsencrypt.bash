#!/usr/bin/env bash

function gen_certificate(){
  _docker run --rm \
      -v "${WORKSPACE}/certs:/etc/letsencrypt" \
      -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
      -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
      -e EMAIL="${LETSENCRYPT_EMAIL}" \
      -e DOMAINS="${DOMAINS}" \
      -e USE_STAGING_SERVER="${USE_STAGING_SERVER}" \
      rajasoun/certbot-dns-route53:latest
}

function generate_letsencrypt_cert_for_route53_dns_challenge_on_staging(){
    export USE_STAGING_SERVER=1
    gen_certificate
}

function generate_letsencrypt_cert_for_route53_dns_challenge_on_production(){
    export USE_STAGING_SERVER=1
    gen_certificate
}

