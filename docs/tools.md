brew install entr
 ls -d **/* | entr  ci/check_bats.bash 