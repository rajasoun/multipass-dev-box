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
through cloud-init configuration by editing the /etc/netplan/50-cloud-init.yaml through script
Refer [cloud-init](config/cloud-init-template.yaml) Template file



