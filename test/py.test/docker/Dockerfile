FROM python AS py-runtime

FROM py-runtime AS py-runtime-testindra
RUN set -ex \
    &&  pip install --upgrade paramiko testinfra pytest-tap
