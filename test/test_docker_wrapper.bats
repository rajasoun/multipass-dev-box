#!/usr/bin/env ./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'helpers'

docker_profile_script="./src/multipass/docker_wrapper.bash"
os_profile_script="./src/multipass/os.bash"

setup() {
    echo "SetUp"
}

teardown() {
  echo "teardown"
}

@test ".os_command_is_installed - check for .docker" {
    # shellcheck disable=SC1090
    source ${os_profile_script}
    run os_command_is_installed docker
    assert_success
}


@test "._docker - docker wrapper - interactive mode (conditional tty), with Mount Points - ls mount points" {
    # shellcheck disable=SC1090
    source ${docker_profile_script}
     test -t 1 && USE_TTY="-t" && echo "Input Devise is TTY"  ||  echo "Input Device is Not TTY"
    _docker run  --rm -i ${USE_TTY} cytopia/ansible:latest-tools bash -c "cat /etc/alpine-release"
    assert_success
}

@test "._docker - docker wrapper - with Mount Points -  interactive mode (conditional tty), ls mount points " {
    # shellcheck disable=SC1090
    source ${docker_profile_script}
    test -t 1 && USE_TTY="-t" && echo "Input Devise is TTY"  ||  echo "Input Device is Not TTY"
    _docker run  --rm -i ${USE_TTY}  \
            -v "${PWD}/config":/config \
            cytopia/ansible:latest-tools bash -c "ls -asl /config"
   assert_success
}