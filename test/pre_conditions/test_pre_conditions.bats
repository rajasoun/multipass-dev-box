#!/usr/bin/env ./test/libs/bats/bin/bats

load '../libs/bats-support/load'
load '../libs/bats-assert/load'
load '../helpers'

@test ".precondition.host Check Git Client is Installed & Verify Version (>2)" {
  run git --version
  assert_success
  assert_output --partial 'git version 2'
}

@test ".precondition.host Check multipass is Installed & Verify Version (=>1.)" {
  run multipass version
  assert_success
  assert_output --partial 'multipass  1.'
}

@test ".precondition.host Check curl is  Installed" {
  run curl --version
  assert_success
}

@test ".precondition.host Check Internet Connection" {
   #run dig +short myip.opendns.com @resolver1.opendns.com
   run  curl -Is http://www.google.com | head -1
   assert_success
}
  


