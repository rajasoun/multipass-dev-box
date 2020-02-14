# entr

Run arbitrary commands when files change [entr](https://github.com/eradman/entr/)
Run this file (with 'entr' installed) to watch all files and rerun tests on changes.

```SHELL
brew install entr
ls -d **/* | entr  ci/check_bats.bash
```

