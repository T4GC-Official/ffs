## Prerequisites
* Ansible
* Cloned Repository of GitHub Account

## Quick start
* Ssh keygen (because this is essential)
* Install Ansible
* Run ansible to staging (by default it should pull from the t4gc repo)
* Run ansible to prod

## Pulling code from the repository
* Git clone this repository
* Once the repository is cloned to your local machine, navigate to the ansible directory.
* You will find a `playbook.yml` which is the base ansible script to run different roles(tasks) specified in it.
* Note: Since `playbook.yml` has all the roles mentioned in it. For running specific roles, make sure all the other roles are commented. Make sure "add_permission" and "remove_permission" roles are uncommented.
* There is another directory called roles. Inside this directory, you will find all the different tasks which are carried out in the `playbook.yml`>
* Within the ansible directory, you will find a `hosts` file, which has the details regarding the remote server you are running the script on. Here we can define the parameters for both the staging and production server for the script to run on. For example:

```sh
[staging]
staging_server ansible_host=192.168.1.100 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

[production]
production_server ansible_host=203.0.113.10 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
```
## Optional: Updating hosts

* Changes are pushed to hosts in staging and production using ssh, public keys and ips. You can modify either of these as follows:
* Under ansible directory, enter the `hosts` file. If you want to make changes w.r.t IP Address, change the value of "ansible_host" .Similarly if you want to modify the user, modify the "ansible_user".

## Note
### For running this anible script on a remote host:
* Generate the public key of your local host using the command "ssh-keygen". Add this publickey to the remote host via the cloud console.
* To verify it,  "cat /.ssh/authorized_key" on the remote host, you should find your public key.
* If you are using a different user other than root, lets say "frappe", copy the `authorized_key`file to "/hom/frappe/.shh/".
* For cloning th egit repo as non-interactive mode, add the publickey of remote host in the github account of yours as SSH key.


## Pushing Changes to Production
* Merge your changes into the main branch(or specific branch for staging or production) on git
* Push your changes to staging:
```
$ cd ffs/ansible
$ ansible-playbook -i hosts playbook.yml -e sitename=<your_sitename> --limit staging
```
* Test your changes in staging
* Push your changes to production
```
$ cd ffs/ansible
$ ansible-playbook -i hosts playbook.yml -e sitename=<your_sitename> --limit production
```
* Test your changes in production


## Note: This method is used to run specific commands, updates or installation without SSH into the server.
