FROM python:3.8.1-alpine3.11 AS py-runtime

FROM py-runtime AS py-runtime-testindra
RUN set -ex \
    &&  pip install --upgrade paramiko testinfra pytest-tap
