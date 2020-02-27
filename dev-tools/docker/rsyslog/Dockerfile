FROM alpine as base

## user and group is added as workaround
## for mounting keys at user level instead of root level
FROM base AS rsyslog-server
ENV TZ=UTC
RUN set -ex \
    &&  apk add --no-cache --update rsyslog bash\
    &&  rm -rf /tmp/* \
    &&  rm -rf /var/tmp/* \
    &&  rm -rf /var/cache/apk/*

EXPOSE 514/tcp 514/udp
VOLUME /var/log
WORKDIR /var/log
ENTRYPOINT ["rsyslogd", "-n"]