# Installation Instruction

### Multipass

Multipass is a lightweight VM manager or Virtualization Orchestrator for Linux, Windows and macOS.
It uses KVM on Linux, Hyper-V on Windows and HyperKit on macOS to run the VM with minimal overhead. 
Its main advantage over Vagrant is that it's a lot less complex and eliminates the need for learning yet another DSL
@TODO: ADR for Multipass

Features:

1. Provides a command line interface to launch, manage and generally fiddle about with instances of Linux.
2. Supports metadata for cloud-init, so it's possible to simulate a small cloud deployment from your laptop or desktop.


On Linux it's available as a snap:

```
sudo snap install multipass --classic
```

For macOS, you can download the installers [from Multipass Site](https://multipass.run/) or [use Homebrew](https://github.com/Homebrew/brew)

```
# Note, this may require you to enter your password for some sudo operations during install
brew cask install multipass
```

On Windows, download the installer [from Multipass Site](https://multipass.run/) or [use SCOOP](https://scoop.sh/) 

*@TODO*: SCOOP support to be added in https://github.com/rajasoun/dev-box-bucket

```
scoop install multipass 
```

### Docker Desktop

Docker Desktop is an application for MacOS and Windows machines for the building and sharing of containerized applications and microservices.
It enables building Kubernetes-ready applications on the laptop
Docker Desktop is used as complementary to multipass in order to provide complete isolation and to achieve 
Immutable IaaC (Infrastructure as Code)
@TODO: ADR for Docker Desktop - Hint Multipass provides complete isolation and destroy when needed

On Linux it's available as a [snap]:

```
sudo snap install docker
```

For macOS, you can download the installers [Docker Desktop] 

On Windows, download the installer [Docker Desktop]

[Home](../ReadMe.md)

[snap]: https://snapcraft.io/install/docker/ubuntu
[Docker Desktop]: https://www.docker.com/products/docker-desktop