FROM golang:1.13.8-alpine3.11 AS go-runtime

FROM go-runtime AS clat
# Install claat tool
# https://github.com/googlecodelabs/tools/blob/master/claat/README.md#install
RUN set -ex \
    &&  apk add --no-cache --update git\
    &&  rm -rf /tmp/* \
    &&  rm -rf /var/tmp/* \
    &&  rm -rf /var/cache/apk/* \
    &&  CGO_ENABLED=0 go get github.com/googlecodelabs/tools/claat

FROM clat

WORKDIR /app
#COPY --from=0 /go/bin/claat /claat

EXPOSE 9500
VOLUME /app

ENTRYPOINT ["claat"]