#!/bin/bash

set -ex

# Install git if not installed (on Ubuntu/Debian)
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Installing..."
    sudo apt update && sudo apt install git -y
fi

# Prompt for user email if not set
git_user_email=$(git config --global user.email)
if [ -z "$git_user_email" ]; then
    echo "Git email is not set. Please provide your email:"
    read -r user_email
    git config --global user.email "$user_email"
else
    echo "Git email is already set to $git_user_email"
fi

# Configure git user (if not already configured)
git_user_name=$(git config --global user.name)
if [ -z "$git_user_name" ]; then
    echo "Git user name is not set. Please provide your name:"
    read -r user_name
    git config --global user.name "$user_name"
else
    echo "Git user name is already set to $git_user_name"
fi

# Setup SSH key if not already present
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "No SSH key found, generating a new one."
    ssh-keygen -t rsa -b 4096 -C "$git_user_email" -f ~/.ssh/id_rsa
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    echo "Add this SSH key to GitHub: $(cat ~/.ssh/id_rsa.pub)"
    echo ""
    echo "Have you added the SSH key to GitHub? (y/n)"
    read -r confirmation
    while [[ "$confirmation" != "y" ]]; do
        echo "Please add the SSH key to GitHub and then confirm by typing 'y'"
        read -r confirmation
    done
fi

# Define the tags
tags="default"

# Ask user if they want to install Docker
echo "Do you want to install Docker? (y/n)"
read -r docker_choice
if [ "$docker_choice" == "y" ]; then
    tags="$tags,docker"
fi

# Ask user if they want to install Java
echo "Do you want to install Java related things (Java, IntelliJ Ultimate + CE)? (y/n)"
read -r java_choice
if [ "$java_choice" == "y" ]; then
    tags="$tags,java"
fi

# Ask user if they want to install Python
echo "Do you want to install Python related things (Python, PyCharm Ultimate + CE)? (y/n)"
read -r python_choice
if [ "$python_choice" == "y" ]; then
    tags="$tags,python"
fi

# Ask user if they want to install Node.js
echo "Do you want to install Node.js related things (nvm)? (y/n)"
read -r node_choice
if [ "$node_choice" == "y" ]; then
    tags="$tags,node"
fi

# Ask user if they want to install CLion
echo "Do you want to install CLion? (y/n)"
read -r clion_choice
if [ "$clion_choice" == "y" ]; then
    tags="$tags,clion"
fi

# Ask user if they want to install VSCode
echo "Do you want to install VSCode? (y/n)"
read -r vscode_choice
if [ "$vscode_choice" == "y" ]; then
    tags="$tags,vscode"
fi

# Ask user if they want to install AWS
echo "Do you want to install AWS? (y/n)"
read -r aws_choice
if [ "%aws_choice" == "y" ]; then
    tags="$tags,aws"
fi

# Ask user if they want to install Android Studio
echo "Do you want to install Android Studio? (y/n)"
read -r android_studio_choice
if [ "%android_studio_choice" == "y" ]; then
    tags="$tags,android-studio"
fi


# Install Ansible
if ! command -v ansible &> /dev/null; then
    echo "Installing Ansible..."
    sudo apt update
    sudo apt install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
else
    echo "Ansible is already installed."
fi

# Clone Dev-Machine-Setup repo
if [ ! -d ~/dev-machine-setup ]; then
    git clone git@github.com:JulianGlattki/dev-machine-setup.git ~/dev-machine-setup
else
    echo "Repository already cloned."
fi

# Run the playbook with the specified tags
echo "Running Ansible playbook with tags: $tags"
ansible-playbook ~/dev-machine-setup/ansible/setup.yml -i local, --connection=local --ask-become-pass --tags "$tags"
