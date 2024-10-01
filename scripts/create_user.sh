#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0; then
    echo "This script must be run as root"
    exit 1
fi

# Check if the correct number of parameters is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <username> <ssh_public_key>"
    exit 1
fi

USERNAME=$1
SSH_KEY=$2

# Create a new user without a password and add to the sudo group
adduser --disabled-password --gecos "" "$USERNAME"

# Add the new user to the sudo group
usermod -aG sudo "$USERNAME"

# Configure sudo to not ask for a password for the new user
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/"$USERNAME"
chmod 0440 /etc/sudoers.d/"$USERNAME"

# Create .ssh directory for the new user with correct permissions
mkdir -p /home/"$USERNAME"/.ssh
chmod 700 /home/"$USERNAME"/.ssh

# Add the SSH public key to the authorized_keys file
echo "$SSH_KEY" > /home/"$USERNAME"/.ssh/authorized_keys
chmod 600 /home/"$USERNAME"/.ssh/authorized_keys

# Change ownership of the home directory and .ssh directory
chown -R "$USERNAME":"$USERNAME" /home/"$USERNAME"/.ssh

echo "User $USERNAME created, added to sudo group, and SSH key added successfully."
echo "Sudo configuration updated for user '$USERNAME' to not require a password."
