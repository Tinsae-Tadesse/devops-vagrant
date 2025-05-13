# Hosting a Website with Vagrant, Apache2, and vagrant-hostmanager

## Overview
This guide walks you through setting up a local development environment using Vagrant, Apache2, and the vagrant-hostmanager plugin. The website content is cloned from a GitHub repository into the virtual machine and served via Apache2.

## 📋 Prerequisites
Install [Virtual Box](https://www.virtualbox.org/wiki/Downloads)
Install [Vagrant](https://developer.hashicorp.com/vagrant/install)
Install [Vagrant Hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager) plugin
```
vagrant plugin install vagrant-hostmanager
```

## 🌐 Accessing the Website

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

