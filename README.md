# DevOps: Git + Vagrant

## Getting started

To make it easy for you to get started with this GitHub repository, follow the below list of recommended next steps.

## Add your files

- [ ] Clone this repository and tell `git` start tracking changes.
```
git clone https://gitlab.com/tinsaetadesse2015/devops-git.git
cd devops-git
git init --initial-branch=dev
git add --all
```
- [ ] Apply the neccessary changes to the cloned files and push the new change to an existing Git repository.
```
git remote add origin https://github.com/Tinsae-Tadesse/devops-git.git
git commit --message "initial commit"
git push -u origin dev
```
- [ ] If the above push fails, due to commit differences between local and remote repos, then do the following.
```
git pull origin dev --allow-unrelated-histories
git commit --message "fixed issue"
git push -u origin dev
```

