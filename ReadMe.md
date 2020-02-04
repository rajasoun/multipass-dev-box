# Local Dev Box Setup with Multipass 

Eases Dev Box Setup with Multipass compatible to both Windows and MacOS

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

On Windows, download the installer [from GitHub](https://github.com/canonical/multipass/releases)

### Mac Users
Workaround of [Issue](https://discourse.ubuntu.com/t/troubleshooting-networking-on-macos/12901) 
through cloud-init configuration by editing the /etc/netplan/50-cloud-init.yaml through script.

Refer [cloud-init](config/cloud-init-template.yaml) Template file

### Getting Started
In Terminal Window

```SHELL
$ ./multipass.sh
```

You will get a menu 

  Multipass Manager   
                
        1. Provision
        2. SSH 
        3. Destroy

 Enter your choice [1-3] 

With Defaults

 * 1 - Provision Ubuntu VM 
 * 2 - SSH - SSH to the VM
 * 3 - Destroy - Destroy the VM

 Next Steps 
 
 1. Connect VM via Bastion Host
 2. Configure VM through Ansible
 3. Add Automated Verification

 ## Flow 

SSH Key Setup Overview 

| S.No | HOST                          | VM                                   |
|------|-------------------------------|--------------------------------------|
| 1.   | Generate the SSH Key Pair     | Provision VM with the Public Key     |
|      | [ssh-keygen]                  | [cloud-int] or [Vagrant] or [Packer] |
|      |                               |                                      |
| 2    | Start SSH Agent               |                                      |
|      | [eval "$(ssh-agent -s)"]      |                                      |
|      |                               |                                      |
| 3    | Load Private Key to SSH Agent |                                      |
|      | [ssh-add -K private_key]      |                                      |
|      | or                            |                                      |
|      | [Create ~/.ssh.config] File   |                                      |
|      |                               |                                      |
| 4    | ssh host or ssh user@VM       |                                      |

Quick Reference: 
![alt text](docs/images/ssh_connection_explained.jpg "Quick Reference")
