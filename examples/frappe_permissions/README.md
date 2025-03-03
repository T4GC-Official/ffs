# Ansible example to run bench as frappe user 

This example SSHs in as root, adds a given user (frappe) to the root group temporarily, executes some migration commands as that user, and then removes frappe from the root group. The reason for this dance is twofold: 

1. Frappe "shells" out (eg `os.system("sudo supervisor status")`), for which it needs sudo permission. But always allowing frappe user to become sudo is unsafe. 

2. We need to run the bench commands as the frapper user to retain certain permissions needed by the files it creates, since the frappe user is also the user that runs other frappe processes. 

## Invocation 

Running as follows: 
```
ansible-playbook -i hosts playbook.yml --extra-vars "ansible_become_password=$ANSIBLE_BECOME_PASSWORD" --tags "remove_permissions" 
```
Available `--tag` options found in `playbook.yml`

## Debugging 

* If it hangs, there could be 2 issues: 1. something needs a sudo password, 2. SSH is hanging. You can figure this out by passing `-vvv` to ansible. If you see SSH hanging, eg: 
```
$ ssh -vvv -C -o ControlMaster=auto -o ControlPersist=60s -o 'IdentityFile="/home/desinotorious/.ssh/id_rsa"' -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o 'User="root"' -o ConnectTimeout=10 -o 'ControlPath="/home/desinotorious/.ansible/cp/2530c547ce"' ...
```

You can delete the SSH state directory and retry (`rm -rf ~/.ansible/cp` in this case). 

