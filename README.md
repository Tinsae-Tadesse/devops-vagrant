# Hosting a Website with Vagrant, Apache2, and vagrant-hostmanager

## Overview
This guide walks you through creating a portable development environment using **Vagrant**, serving a static website via **Apache2**, and managing local DNS entries automatically using the **vagrant-hostmanager** plugin. Your website content will be cloned from a **GitHub repository** directly into the VM and served via Apache2.

## ✅ Prerequisites
Before starting, make sure the following tools are installed on your local machine:
- [ ] Install [Virtual Box](https://www.virtualbox.org/wiki/Downloads)
- [ ] Install [Vagrant](https://developer.hashicorp.com/vagrant/install)
- [ ] Install [Vagrant Hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager) plugin for managing local name entries:
```
vagrant plugin install vagrant-hostmanager
```

## 📁 Project Directory Structure
Create a new directory for your project:
```
my-static-site/
├── assets/
├── images/
├── vagrant-scripts/
├── vagrant-scripts/provision.sh
├── index.html
├── Vagrantfile
```
- `Vagrantfile`: Configuration file for the vagrant virtual machine
- `vagrant-scripts/provision.sh`: Shell script to provision Apache2 and fetch your site content

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

