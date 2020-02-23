FROM python AS py-runtime

## user and group is added as workaround
## for mounting keys at user level instead of root level
FROM py-runtime AS py-runtime-testindra
RUN set -ex \
    &&  groupadd -g 2000 py.test \
    &&  useradd -m -u 2001 -g py.test py.test \
    &&  pip install --upgrade paramiko testinfra pytest-tap

USER py.test
