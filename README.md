# Dev Machine Setup
Tooling to quickly set up my personal dev environment. 

## Usage 
Copy [bootstrap.sh](/bootstrap.sh) to `~` on local machine.

```bash
chmod +x ./bootstrap.sh
./bootstrap.sh
```

The script will set up Git via SSH, pull this repo and run the Ansible playbook with the desired configuration
(always running with the `default` tag, others as specified via the script).

## Available tags for Ansible

The Ansible playbook can also be executed individually using

```bash
ansible-playbook ~/dev-machine-setup/ansible/setup.yml -i local, --connection=local --ask-become-pass --tags <tags>
```

- default
  - Install basic programs (Vim, Curl, etc.)
  - Setup directories
  - Setup aliases
  - Setup zsh
- docker
  - Setup Docker
- java
  - Install Java
  - Install IntelliJ Ultimate
  - Install IntelliJ Community Edition
- python
  - Install Python
  - Install PyCharm Ultimate
  - Install PyCharm Community Edition
- clion
  - Install Clion Ultimate
- vscode
  - Install VSCode 

## Testing
Via [Dockerfile_BareUbuntu](Dockerfile_BareUbuntu) or [Dockerfile_WSLUbuntu](Dockerfile_WSLUbuntu).
