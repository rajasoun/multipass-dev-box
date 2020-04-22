# SSH Setup Flow 
### [Home](../ReadMe.md)

SSH Key Setup Overview 

| S.No |               HOST            |                 VM                   |
|:-----|:------------------------------|:-------------------------------------|
| 1.   | Generate the SSH Key Pair     | Provision VM with the Public Key     |
|      | ssh-keygen                    | cloud-int or Vagrant or Packer       |
| 2    | Start SSH Agent               |                                      |
|      | eval "$(ssh-agent -s)"        |                                      |
| 3    | Load Private Key to SSH Agent |                                      |
|      | ssh-add -K private_key        |                                      |
| 4    | ssh -F <ssh-config> host or   |                                      |
|      | ssh -i <private-key>user@ip   |                                      |

### SSH Keys 

![alt text](images/ssh_connection_explained.jpg "SSH Quick Reference")

## Ansible Concepts

* Controller - the Machine where Ansible installed on it and will manage the whole process
* Inventory - a file has all servers you will manage and they listed in groups as a category or standalone host
* Playbook -a file written in YAML format and it’s a human readable language , and it has all tasks that you want to execute it on the targeted machines
* Task - a block of single procedure to execute something on the remote target like install package (ex:- Nginx)
* Role - A pre-defined way for organizing playbooks for facilitating the provisioning process
* Facts - Global variables containing information about the system, like network interfaces

### Ansible Flow

![alt text](https://miro.medium.com/max/1920/1*XLdN4_LCoASjbArU-ggkTA.png "Ansible Quick Reference")


