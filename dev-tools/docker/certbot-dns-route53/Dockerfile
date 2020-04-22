FROM certbot/certbot AS certbot

FROM certbot AS certbot-dns-route53
ENV TZ=UTC

RUN set -ex \
    &&  echo "Install certbot plugins" \
    &&  pip3 install -U certbot-dns-route53 \
    &&  rm -rf /tmp/* \
    &&  rm -rf /var/tmp/* \
    &&  rm -rf /var/cache/apk/*

WORKDIR /opt/certbot

COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/opt/certbot/entrypoint.sh"]