#Steps to run the ansible script from local host on a remote server

###Install ansible on your local machine.
###Git clone this repository
###Once the repository is cloned to your local machine, navigate to the ansible directory.
###You will find a playbook.yml which is the base ansible script to run different roles(tasks) specified in it.
###Within the ansible directory, you will find a hosts file, which has the details regarding the remote server you are running the script on. Here we can define the parameters for both the staging and production server for the script to run on. For example:
```sh
[staging]
staging_server ansible_host=192.168.1.100 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

[production]
production_server ansible_host=203.0.113.10 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
```

###There is another directory called roles. Inside this directory, you will find all the different tasks which are carried out in the playbook.yml file.
##In order to pull the latest changes onto the staging or the production, you will have to run the following command:

```sh
Staging:
ansible-playbook -i hosts playbook.yml -e sitename=<your_sitename> --limit staging

Production:
ansible-playbook -i hosts playbook.yml -e sitename=<your_sitename> --limit production
```

##Note: This method is used to run specific commands, updates or installation without SSH into the server.
