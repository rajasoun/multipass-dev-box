#!/usr/bin/env ./test/libs/bats/bin/bats

load '../libs/bats-support/load'
load '../libs/bats-assert/load'
load '../helpers'

@test ".precondition.host.docker Check Docker is Installed & Verify Version (>19.03)" {
  run docker --version
  assert_success
  assert_output --partial 'Docker version 19.03.5'
}

@test ".precondition.host.docker Check Docker Compose is Installed & Verify Version (>1.25)" {
  run docker-compose --version
  assert_success
  assert_output --partial 'docker-compose version 1.25'
}

@test ".precondition.host.docker Check Docker Works with hello-world image" {
  run docker run --rm hello-world
  assert_success
  assert_output --partial 'Hello from Docker!'
}


