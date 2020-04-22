FROM node:13.10.1-alpine3.11 AS node-runtime

FROM node-runtime AS webtail
RUN set -ex \
    &&  npm install -g frontail\
    &&  rm -rf /tmp/* \
    &&  rm -rf /var/tmp/* \
    &&  rm -rf /var/cache/apk/*

VOLUME /logs
WORKDIR /logs

ENTRYPOINT ["frontail"]
CMD ["--help"]