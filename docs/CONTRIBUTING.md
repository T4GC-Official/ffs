# Contributing 

We take pull requests. Here is an outline of the github pr flow. 

* Visit https://github.com/T4GC-Official/ffs
* Click Fork button (top right) to create your fork

<img src="https://github.com/T4GC-Official/ffs/raw/main/images/fork.png" width="300">
 
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

<img src="https://github.com/T4GC-Official/ffs/raw/main/images/pr.png" width="300">

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
