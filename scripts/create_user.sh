#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
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

# Create a new user without a password
useradd -m -s /bin/bash "$USERNAME"

# Create .ssh directory for the new user
mkdir -p /home/"$USERNAME"/.ssh

# Add the SSH public key to the authorized_keys file
echo "$SSH_KEY" > /home/"$USERNAME"/.ssh/authorized_keys

# Set the correct permissions
chmod 700 /home/"$USERNAME"/.ssh
chmod 600 /home/"$USERNAME"/.ssh/authorized_keys

# Change ownership of the .ssh directory and its contents
chown -R "$USERNAME":"$USERNAME" /home/"$USERNAME"/.ssh

echo "User $USERNAME created and SSH key added successfully."
