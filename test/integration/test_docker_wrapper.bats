#!/usr/bin/env ./test/libs/bats/bin/bats

load 'init_integration_test'

docker_profile_script="./src/lib/docker_wrapper.bash"
os_profile_script="./src/lib/os.bash"

setup() {
    echo "SetUp"
}

teardown() {
  echo "teardown"
}

@test ".integration.os_command_is_installed - check for .docker" {
    # shellcheck disable=SC1090
    source ${os_profile_script}
    run os_command_is_installed docker
    assert_success
}


@test ".integration._docker - docker wrapper - interactive mode (conditional tty), with Mount Points - ls mount points" {
    # shellcheck disable=SC1090
    source ${docker_profile_script}
     test -t 1 && USE_TTY="-t" && echo "Input Devise is TTY"  ||  echo "Input Device is Not TTY"
    _docker run  --rm -i ${USE_TTY} cytopia/ansible:latest-tools bash -c "cat /etc/alpine-release"
    assert_success
}

@test ".integration._docker - docker wrapper - with Mount Points -  interactive mode (conditional tty), ls mount points " {
    # shellcheck disable=SC1090
    source ${docker_profile_script}
    test -t 1 && USE_TTY="-t" && echo "Input Devise is TTY"  ||  echo "Input Device is Not TTY"
    _docker run  --rm -i ${USE_TTY}  \
            -v "${PWD}/config":/config \
            cytopia/ansible:latest-tools bash -c "ls -asl /config"
   assert_success
}