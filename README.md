# The Flake Fleet Scheduler (ffs)

Fleet management for the Flake platform. 

## Contributing

See [CONTRIBUTING.md](./docs/CONTRIBUTING.md)

## Provisioning 

### Provisioning a VM

If you already have a VM, skip to the next section. Otherwise, read [HOSTS.md](./docs/HOSTS.md) guide to provision a VM. 

### Provisioning flake/frappe onto the VM
Checkout [https://github.com/T4GC-Official/frappe-deployment-doc/tree/Final_doc] for setting up Frappe and it's dependent packages installations.


1. Generate ssh keys 
2. Add public key to vm with ip under `ansible_host`
3. Point `ansible_ssh_private_key_file` to private key ...
4. Generate a public/private key for github and add it to the repo
5. set the `key_file` variable to the path of the private key 
6. Run this command 
```console
$ ansible-playbook foo.yaml ...
```


## Update sites 

Run 
```console
$ ansible-playbook -e <sitename>
```
All sites are currently read from the production server's `frappe-bench` directory.


