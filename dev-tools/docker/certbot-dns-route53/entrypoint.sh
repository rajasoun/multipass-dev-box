#!/usr/bin/env sh

certbot certonly -n \
  $([ -n "${USE_STAGING_SERVER}" ] && echo "--test-cert") \
  --agree-tos \
  --email "${EMAIL}" \
  --dns-route53 \
  --dns-route53-propagation-seconds 30 \
  -d "${DOMAINS}"