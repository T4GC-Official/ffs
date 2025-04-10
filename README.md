# The Flake Fleet Scheduler (ffs)

Fleet management for the Flake platform. 

## Contributing

See [CONTRIBUTING.md](./docs/CONTRIBUTING.md)

## Provisioning 

...here document whatever is needed to get the current script running. Eg: 

This document first assumes you have run all the "common" frappe provisioning steps. You can find those [here]( - insert link to frappe setup docs - ).

1. Generate ssh keys 
2. Add public key to vm with ip under `ansible_host`
3. Point ansible_ssh_private_key_file to private key ...
4. Generate a public/private key for github and add it to the repo
5. set the `key_file` variable to the path of the private key 
6. Run this command 
ansible-playbook foo.yaml ...


## Update sites 

Run 
```
$ cd ansible 
$ ansible-playbook -e <sitename> playbooks/frappe.yml
```
All sites are currently read from the production server's `frappe-bench` directory.
