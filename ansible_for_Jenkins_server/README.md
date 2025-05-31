# Jenkins & Terraform Automation with Ansible

This repository contains Ansible roles and playbooks to install and configure Jenkins and Terraform on a remote server. It also includes instructions for setting up your control machine for Ansible management.

---

## Prerequisites

- Ubuntu/Debian-based remote server (app-server) with SSH access
- Ansible installed on the control machine
- SSH private key for the remote server (`jenkins-server.pem`)

---

## Control Machine Setup

1. **Install Ansible**

```bash
sudo apt update
sudo apt install ansible
```

2. **Configure SSH**

Create or edit your SSH config file:

```bash
vim ~/.ssh/config
```

Add the following:

```bash
Host app-server
    Hostname Your_Host_IP
    IdentityFile /path/to/jenkins-server.pem
    User ubuntu
    StrictHostKeyChecking no
```

3. **Prepare SSH Key from AWS Secrets Manager SSH**

```bash
aws secretsmanager get-secret-value \
  --secret-id private_key \
  --query SecretString \
  --output text > sshkey.pem

chmod 400 sshkey.pem
```

3. **Update /etc/hosts On your control machine, add:**

```bash
Your_Host_IP  app-server
```

3. **Create Ansible User on your local machine:**

```bash
sudo useradd -m -s /bin/bash ansible
sudo passwd ansible
#-----------------------------------------------
sudo vim /etc/sudoers.d/ansible
## Add this line to the sudoers file to allow passwordless sudo for ansible user:
 ansible ALL=(ALL) NOPASSWD: ALL
#---------------------------------------------
su - ansible
```

4. **Create Ansible User on Remote Server SSH into your server:**

```bash
ssh app-server
sudo useradd -m -s /bin/bash ansible
sudo passwd ansible  # Set password for ansible user
sudo vim /etc/sudoers.d/ansible
#--------------------------------------------------
# Add this line to the sudoers file to allow passwordless sudo for ansible user:
ansible ALL=(ALL) NOPASSWD: ALL
#--------------------------------------------------
# Enable SSH Password Authentication
sudo vim /etc/ssh/sshd_config
# Ensure the following settings:
PasswordAuthentication yes
# Disable GSSAPI if present:
#GSSAPIAuthentication no
#--------------------------------------------------
# Restart SSH:
sudo systemctl restart sshd
```
5. **Configure SSH Key Authentication for ansible user in your local machine**

```bash
# Switch to ansible user:
su - ansible
ssh-keygen  # Generate SSH key pair if not exists
ssh-copy-id app-server
#-------------------------------------------
# Edit SSH config for ansible user:
vim ~/.ssh/config
#-------------------------------------------
# Add:
Host app-server
    Hostname Your_Host_IP
    IdentityFile ~/.ssh/id_rsa
    User ansible
    StrictHostKeyChecking no
```

5. **Verify Ansible Connectivity**

```bash
ansible node --list-hosts
ansible node -m ping
```

## Ansible Roles
**Jenkins Role**
This role performs:

Cleanup of old Jenkins repository and keys

Adds Jenkins GPG key and repository

Installs Java 17 and Jenkins

Ensures Jenkins service is started and enabled

**Terraform Role**
This role performs:

Installs unzip package

Downloads Terraform binary

Unzips and places Terraform in /usr/local/bin

Ensures Terraform binary is executable

## Run the playbook

```bash
ansible-playbook site.yml
```

## Access Jenkins

After playbook completion:
To get the Jenkins initial admin password(you can take it from output of the playbook)

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

## Open Jenkins UI in your browser at:

```bash
http://Your_Host_IP:8080
# Install recommended plugins and continue setup.
# we now ready to run the pipeline ^_^
```
