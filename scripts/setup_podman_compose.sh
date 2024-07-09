#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 -e EMAIL -p PROJECT_NAME"
    echo "  -e EMAIL          Your email address for SSH key generation"
    echo "  -p PROJECT_NAME   The name of your project"
    exit 1
}

# Parse command line arguments
while getopts ":e:p:" opt; do
  case $opt in
    e) EMAIL=$OPTARG ;;
    p) PROJECT_NAME=$OPTARG ;;
    *) usage ;;
  esac
done

# Check if email and project name are provided
if [ -z "$EMAIL" ] || [ -z "$PROJECT_NAME" ]; then
    usage
fi

# Update and install necessary packages
echo "Updating package list and installing necessary packages..."
sudo apt update
sudo apt install -y podman python3-pip python3-venv git dbus slirp4netns

# Create and activate the virtual environment
echo "Creating and activating virtual environment for Podman Compose..."
python3 -m venv ~/podman_env
source ~/podman_env/bin/activate

# Install Podman Compose
echo "Installing Podman Compose..."
pip install podman-compose

# Verify Podman Compose installation
echo "Verifying Podman Compose installation..."
podman-compose --version

# Automatically activate the virtual environment on SSH
echo "Configuring shell to automatically activate the virtual environment on SSH login..."

# For Bash
if [ -f ~/.bashrc ]; then
    echo "source ~/podman_env/bin/activate" >> ~/.bashrc
    source ~/.bashrc
fi

# For Zsh
if [ -f ~/.zshrc ]; then
    echo "source ~/podman_env/bin/activate" >> ~/.zshrc
    source ~/.zshrc
fi

# Generate SSH key
echo "Generating SSH key..."
ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/id_ed25519 -N ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Add SSH key to GitHub account manually
echo "Copy the following SSH key and add it to your GitHub account:"
cat ~/.ssh/id_ed25519.pub
read -p "Press enter after adding the SSH key to GitHub..."

# Create a directory in /etc/ for the project
echo "Creating directory in /etc/ for the project..."
sudo mkdir -p /etc/$PROJECT_NAME
sudo chown $USER:$USER /etc/$PROJECT_NAME

# Pull code from GitHub
echo "Pulling code from GitHub..."
cd /etc/$PROJECT_NAME
git clone git@github.com:your_username/your_repository.git

# Install NVM and Node.js
echo "Installing NVM and Node.js..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts

# Verify Node.js installation
node -v
npm -v

# Configure default registries for Podman
echo "Configuring default registries for Podman..."
sudo bash -c 'cat > /etc/containers/registries.conf << EOF
[registries.search]
registries = ["docker.io", "quay.io", "registry.fedoraproject.org"]
EOF'

# Install Hasura CLI
echo "Installing Hasura CLI..."
curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash

# Verify Hasura CLI installation
hasura version

# Modify net.ipv4.ip_unprivileged_port_start to allow rootless users to bind to ports 80 and 443
echo "Modifying /etc/sysctl.conf to allow rootless users to bind to ports 80 and 443..."
sudo bash -c 'echo "net.ipv4.ip_unprivileged_port_start=80" >> /etc/sysctl.conf'
sudo sysctl -p

# Enable lingering for the user
echo "Enabling lingering for the user..."
sudo loginctl enable-linger $USER

# Enable and start Podman service for the user
echo "Enabling and starting Podman service for the user..."
systemctl --user enable podman
systemctl --user start podman

# Configure Podman to use cgroupfs as the cgroup manager
echo "Configuring Podman to use cgroupfs as the cgroup manager..."
mkdir -p ~/.config/containers
cat > ~/.config/containers/containers.conf << EOF
[engine]
cgroup_manager = "cgroupfs"
EOF

# Print completion message
echo "Setup complete! You are now ready to use Podman Compose on your Debian instance."
echo "Don't forget to add your SSH key to your GitHub account if you haven't already."
