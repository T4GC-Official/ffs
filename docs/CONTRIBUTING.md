# Contributing 

We take pull requests. Here is an outline of the github pr flow. 

* Visit https://github.com/T4GC-Official/ffs
* Click Fork button (top right) to create your fork

<img src="https://github.com/T4GC-Official/count/raw/main/images/fork.png" width="300">
 
* Create your clone (where `$user` is your github username):
```
$ git clone git@github.com:$user/ffs.git
$ cd ffs
$ git remote add upstream https://github.com/T4GC-Official/ffs

# Block upstream main from pushes
$ git remote set-url --push upstream blocked_for_push

# Check your remotes 
$ git remote -v 
```
* Rebase and sync
```
$ git checkout main
$ git fetch upstream && git rebase upstream/main
```
* Create a branch to make your changes 
```
$ git checkout -b feature_foobar
# make your changes on the feature_foobar branch
```
* Creating a pr 
```
$ git add your_file
$ git commit 
$ git push -f origin feature_foobar 
```
* Visit your fork `https://github.com/$user/ffs`
* Click the Compare & Pull Request button next to your `feature_foobar` branch. This will create a pull request, assign it to someone for code review

<img src="https://github.com/T4GC-Official/count/raw/main/images/pr.png" width="300">

* Modify code locally 
* Re-commit
```
$ git commit -a --amend 
```
* Re-push
```
$ git push -f origin feature_foobar 
```
* Once your pr is merged, fetch and rebase 
```
$ git checkout main 
$ git fetch origin
$ git rebase origin/main 
$ gith checkoub -b feature_foobar_2
```

## Adding new scripts 

For your understanding, here is a conceptual layout of this repo. Place your scripts in the appropriate directory. 

```console 
ansible/
├── README.md
├── inventories/ (currently unimplemented) 
│   ├── staging/
│   │   ├── hosts.yml (currently this is combined in a global hosts file)
│   │   └── group_vars/
│   │       └── all.yml
│   └── production/
│       ├── hosts.yml (currently this is combined in a global hosts file) 
│       └── group_vars/
│           └── all.yml
├── playbooks/ (this has "server" specific scripts, eg frappe calls bench install and bench update) 
│   ├── frappe.yml
│   ├── cloudflare_tunnel.yml
│   ├── grafana.yml
│   └── site.yml  # calls the other playbooks for full-stack provisioning
├── roles/ (this has individual tasks done within a server, eg bench update for frappe) 
│   ├── frappe/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   └── vars/
│   │       └── main.yml
│   ├── cloudflare_tunnel/
│   │   └── ...
│   └── grafana/
│       └── ...
├── files/
│   └── common config files or binaries (nothing here now) 
├── group_vars/
│   └── all.yml (all variables, or role-specific if needed)
├── host_vars/
│   └── <hostname>.yml
└── ansible.cfg (global ansible configs, eg where roles/ directory is) 
```

