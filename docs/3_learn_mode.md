### [Home](../ReadMe.md)

#### Help (Flow) Based - Beginners 

```SHELL
$ export MODE=help && ./multipass.bash
```

#### Menu Based - Intermediate 

In Terminal Window

```SHELL
$ export MODE=menu && ./multipass.bash 
```

#### API Based - For Automated Testing & Aggregation - Advanced

In Terminal 
   
```SHELL
$ OPT=_API_ID_ or _API_NAME_
$ export MODE=api && ./multipass.bash $OPT
```

[API List](docs/2_apis.md)


### Automated Tests

In Terminal Window

```SHELL
$ ci/check_bats.bash unit
$ ci/check_bats.bash integration
$ ci/check_bats.bash docker
```

To run tests based on name 
```SHELL
$ ci/check_bats.bash -f .ssh
```