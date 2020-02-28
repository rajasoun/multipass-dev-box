FROM golang:1.13.8-alpine3.11 AS go-runtime

## user and group is added as workaround
## for mounting keys at user level instead of root level
FROM go-runtime AS ccat
ENV TZ=UTC
RUN set -ex \
    &&  apk add --no-cache --update git\
    &&  rm -rf /tmp/* \
    &&  rm -rf /var/tmp/* \
    &&  rm -rf /var/cache/apk/* \
    &&  go get -u github.com/jingweno/ccat

VOLUME /ccat
WORKDIR /ccat

ENTRYPOINT ["ccat"]
CMD ["--help"]