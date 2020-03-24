FROM golang:1.13.8-alpine3.11 AS go-runtime

FROM go-runtime AS ccat
# Install claat tool
# https://github.com/googlecodelabs/tools/blob/master/claat/README.md#install
RUN CGO_ENABLED=0 go get github.com/googlecodelabs/tools/claat

FROM scratch

WORKDIR /app
COPY --from=0 /go/bin/claat /claat

EXPOSE 9500
VOLUME /app

ENTRYPOINT ["/claat"]