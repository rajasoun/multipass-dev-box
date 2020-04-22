### [Home](../ReadMe.md)

| API ID  |              API NAME           |  Purpose                            |
|:--------|:--------------------------------|:------------------------------------|
| 10      | provision_vm                    | Create VM                           |
| 20      | provision_bastion               | Pull Docker Image for Bastion VM    |
| 30      | ansible_ping_from_bastion_to_vm | Ping VM through Ansible             |
| 40      | ssh_to_bastion_vm               | SSH to VM                           |
| 50      | configure_vm_from_bastion       | Configure VM using Ansible          |
| 60      | test_base_infra                 | Test Base Infra                     |
| 70      | test_infra                      | Test Complete Infra                 |
| 80      | list_all_vms                    | List all VMs                        |
| 90      | destroy_vm                      | Destroy VM                          |