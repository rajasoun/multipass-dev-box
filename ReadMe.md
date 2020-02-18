# Local Dev Box Setup with Multipass 

Travis CI (Linux Only) [![Build Status](https://travis-ci.org/rajasoun/multipass-dev-box.svg?branch=master)](https://travis-ci.org/rajasoun/multipass-dev-box) 

GitHub Actions CI (Linux, Mac & Windows) ![CI](https://github.com/rajasoun/multipass-dev-box/workflows/CI/badge.svg)


Eases Dev Box Setup with Multipass compatible to both Windows and MacOS

Limitations: 
Multipass will not work on Mac when connected to Cisco Any Connect. 

References:
---
    1. https://github.com/canonical/multipass/issues/961
    2. https://multipass.run/docs/troubleshooting-networking-on-macos
    3. https://discourse.ubuntu.com/t/troubleshooting-networking-on-macos/12901

### Multipass

Multipass is a lightweight VM manager for Linux, Windows and macOS. 

*Install Multipass*

On Linux it's available as a snap:

```
sudo snap install multipass --classic
```

For macOS, you can download the installers [from GitHub](https://github.com/canonical/multipass/releases) or [use Homebrew](https://github.com/Homebrew/brew):

```
# Note, this may require you to enter your password for some sudo operations during install
brew cask install multipass
```

On Windows, download the installer [from GitHub](https://github.com/canonical/multipass/releases) or [use SCOOP](https://scoop.sh/):
@TODO: SCOOP support to be added in https://github.com/rajasoun/dev-box-bucket
```
# 
scoop install multipass
```


### Getting Started 

#### Menu Based 

In Terminal Window

```SHELL
$ git submodule update --init --recursive --remote
$ ./multipass.sh
```

You will get a menu 

  Multipass Manager   
  
          1. Provision                  
          2. SSH-Bastion                 
          3. AnsiblePing                   
          4. ConfigureVM
          5. Destroy

 Enter your choice [1-4] 

#### Help (Flow) Based 

```SHELL
$ MENU=help && ./multipass.sh
```

#### API Based - For Automated Testing & Aggregation

| API ID |              API NAME           |
|--------|---------------------------------|
| 1      | provision_vm                    |
| 2      | provision_bastion               |
| 3      | ansible_ping_from_bastion_to_vm |
| 4      | ssh_to_bastion_vm               |
| 5      | configure_vm_from_bastion       |
| 6      | test_infra                      |
| 7      | destroy_vm                      | 
              
In Terminal 
   
```SHELL
$ OPT=_API_ID_ or _API_NAME_
$ MENU=api && ./multipass.sh $OPT
```

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


*ToDo*

     1. Adoption of Git Flow  ✅
     2. Add Automated Verification - CI 
            a. Travis (Linux Only) ✅
            b. GitHub Actions (Linux,Mac & Windows) ✅
     3. Explore Limitations of Multipass + Anyconnect Issue
     4. Configure VM through Ansible
     5. Support for ADR


### What does the Script Do
Automates - Automates - Automates !!!

1. Provides Workaround of [Issue](https://discourse.ubuntu.com/t/troubleshooting-networking-on-macos/12901) 
through cloud-init configuration by editing the /etc/netplan/50-cloud-init.yaml through script.
    * Refer [cloud-init](config/cloud-init-template.yaml) Template file
2. Configuration driven - from provisioning to destroy of VM along with SSH Configuration
3. Ability to connect and configure VM via Bastion Host - Making the experience seamless between Windows & Mac 
4. Test Driven Development for entire suite
5. Modularization of Code for Easy Refactoring
6. Workaround to invoke docker in a common way through wrapper both for windows and mac


### SSH Setup Flow 

SSH Key Setup Overview 

| S.No | HOST                          | VM                                   |
|------|-------------------------------|--------------------------------------|
| 1.   | Generate the SSH Key Pair     | Provision VM with the Public Key     |
|      | [ssh-keygen]                  | [cloud-int] or [Vagrant] or [Packer] |
| 2    | Start SSH Agent               |                                      |
|      | [eval "$(ssh-agent -s)"]      |                                      |
| 3    | Load Private Key to SSH Agent |                                      |
|      | [ssh-add -K private_key]      |                                      |
| 4    | ssh -F <ssh-config> host or   |                                      |
|      | ssh -i <private-key>user@ip   |                                      |

##### SSH Keys 

![alt text](docs/images/ssh_connection_explained.jpg "SSH Quick Reference")

### Ansible Concepts

    * Controller - the Machine where Ansible installed on it and will manage the whole process
    * Inventory - a file has all servers you will manage and they listed in groups as a category or standalone host
    * Playbook -a file written in YAML format and it’s a human readable language , and it has all tasks that you want to execute it on the targeted machines
    * Task - a block of single procedure to execute something on the remote target like install package (ex:- Nginx)
    * Role - A pre-defined way for organizing playbooks for facilitating the provisioning process
    * Facts - Global variables containing information about the system, like network interfaces

##### Ansible Flow

![alt text](https://miro.medium.com/max/1920/1*XLdN4_LCoASjbArU-ggkTA.png "Ansible Quick Reference")