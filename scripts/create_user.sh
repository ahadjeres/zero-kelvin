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

# Create a new user without a password and add to sudo group
adduser --ingroup sudo --disabled-password --gecos "" "$USERNAME"

echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USERNAME

# Create .ssh directory for the new user
mkdir -p /home/"$USERNAME"/.ssh

# Add the SSH public key to the authorized_keys file
echo "$SSH_KEY" > /home/"$USERNAME"/.ssh/authorized_keys

# Set the correct permissions
chmod 700 /home/"$USERNAME"/.ssh
chmod 600 /home/"$USERNAME"/.ssh/authorized_keys

# Change ownership of the .ssh directory and its contents
chown -R "$USERNAME" /home/"$USERNAME"/.ssh

# Configure sudo to not ask for a password for the new user
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/"$USERNAME"
chmod 0440 /etc/sudoers.d/"$USERNAME"

echo "User $USERNAME created, added to sudo group, and SSH key added successfully."
echo "Sudo configuration updated for user '$USERNAME' to not require a password."
