# Setting Up Podman Compose on Debian Instance

This tutorial will guide you through the process of setting up Podman Compose on a Debian instance, including steps to ensure the virtual environment is activated every time you SSH into your server. Additionally, it will cover generating an SSH key to pull code from GitHub, creating a directory in `/etc/` to store the app codebase, installing NVM for Node.js, and resolving common issues related to Podman.

## Table of Contents
1. [Automated Setup Script](#automated-setup-script)
2. [Step 1: Update and Install Necessary Packages](#step-1-update-and-install-necessary-packages)
3. [Step 2: Create and Activate the Virtual Environment](#step-2-create-and-activate-the-virtual-environment)
4. [Step 3: Install Podman Compose](#step-3-install-podman-compose)
5. [Step 4: Verify the Installation](#step-4-verify-the-installation)
6. [Step 5: Automatically Activate the Virtual Environment on SSH](#step-5-automatically-activate-the-virtual-environment-on-ssh)
    - [For Bash Users](#for-bash-users)
    - [For Zsh Users](#for-zsh-users)
7. [Step 6: Generate an SSH Key](#step-6-generate-an-ssh-key)
8. [Step 7: Create a Directory in `/etc/` for the Project](#step-7-create-a-directory-in-etc-for-the-project)
9. [Step 8: Pull Code from GitHub](#step-8-pull-code-from-github)
10. [Step 9: Install NVM (Node Version Manager) and Node.js](#step-9-install-nvm-node-version-manager-and-nodejs)
11. [Step 10: Configure Default Registries for Podman](#step-10-configure-default-registries-for-podman)
12. [Step 11: Install Hasura CLI Using the Official Script](#step-11-install-hasura-cli-using-the-official-script)
13. [Step 12: Resolve Common Issues](#step-12-resolve-common-issues)
    - [Issue 1: `slirp4netns` and `dbus-launch` Error](#issue-1-slirp4netns-and-dbus-launch-error)
    - [Issue 2: Exposing Privileged Ports 80 and 443](#issue-2-exposing-privileged-ports-80-and-443)
14. [Summary](#summary)

## Automated Setup Script

To automate the setup process, you can use the following script. This script accepts parameters for your email address and project name.

### Usage
```bash
./scripts/setup_podman_compose.sh -e your_email@example.com -p your_project_name
```

## Step 1: Update and Install Necessary Packages

Update the package list and install Podman, Python pip, the virtual environment package, and Git:

```bash
sudo apt update
sudo apt install podman python3-pip python3-venv git -y
```

## Step 2: Create and Activate the Virtual Environment

Create a virtual environment for Podman Compose:

```bash
python3 -m venv ~/podman_env
```

Activate the virtual environment:

```bash
source ~/podman_env/bin/activate
```

## Step 3: Install Podman Compose

Within the activated virtual environment, install Podman Compose:

```bash
pip install podman-compose
```

## Step 4: Verify the Installation

Ensure Podman Compose is installed correctly by checking its version:

```bash
podman-compose --version
```

## Step 5: Automatically Activate the Virtual Environment on SSH

To ensure the virtual environment is activated every time you SSH into your Debian server, add the activation command to your shell's startup script.

### For Bash Users

1. Open the `~/.bashrc` file in a text editor:

   ```bash
   nano ~/.bashrc
   ```

2. Add the following line to the end of the file:

   ```bash
   source ~/podman_env/bin/activate
   ```

3. Save and close the file. In `nano`, you can save by pressing `CTRL + O`, then press `ENTER` to confirm. Close the editor by pressing `CTRL + X`.

4. Reload the startup script to apply the changes:

   ```bash
   source ~/.bashrc
   ```

### For Zsh Users

1. Open the `

~/.zshrc` file in a text editor:

   ```bash
   nano ~/.zshrc
   ```

2. Add the following line to the end of the file:

   ```bash
   source ~/podman_env/bin/activate
   ```

3. Save and close the file. In `nano`, you can save by pressing `CTRL + O`, then press `ENTER` to confirm. Close the editor by pressing `CTRL + X`.

4. Reload the startup script to apply the changes:

   ```bash
   source ~/.zshrc
   ```

## Step 6: Generate an SSH Key

To securely pull code from GitHub, generate an SSH key and add it to your GitHub account.

1. Generate a new SSH key pair:

   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

   If you are using an older system that does not support the `ed25519` algorithm, you can use `rsa`:

   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```

2. When prompted to "Enter a file in which to save the key," press `ENTER` to accept the default file location.

3. When prompted, enter a secure passphrase (optional).

4. Add your SSH key to the SSH agent:

   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
   ```

   For RSA, the command would be:

   ```bash
   ssh-add ~/.ssh/id_rsa
   ```

5. Copy the SSH key to your clipboard:

   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

   For RSA, the command would be:

   ```bash
   cat ~/.ssh/id_rsa.pub
   ```

6. Log in to your GitHub account, navigate to **Settings > SSH and GPG keys**, and click **New SSH key**. Paste your SSH key into the "Key" field and give it a descriptive title.

## Step 7: Create a Directory in `/etc/` for the Project

1. Create the directory in `/etc/`:

   ```bash
   sudo mkdir /etc/your_project_name
   ```

2. Change the ownership of the directory to your user:

   ```bash
   sudo chown $USER:$USER /etc/your_project_name
   ```

## Step 8: Pull Code from GitHub

1. Navigate to the newly created directory:

   ```bash
   cd /etc/your_project_name
   ```

2. Clone your repository using SSH:

   ```bash
   git clone git@github.com:your_username/your_repository.git
   ```

## Step 9: Install NVM (Node Version Manager) and Node.js

1. Download and install NVM:

   ```bash
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
   ```

2. Load NVM into the current shell session:

   ```bash
   export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
   ```

3. Install the latest LTS version of Node.js:

   ```bash
   nvm install --lts
   ```

4. Verify the installation:

   ```bash
   node -v
   npm -v
   ```

## Step 10: Configure Default Registries for Podman

1. Open the `/etc/containers/registries.conf` file in a text editor:

   ```bash
   sudo vim /etc/containers/registries.conf
   ```

2. Add the following configuration under the `[registries.search]` section:

   ```plaintext
   [registries.search]
   registries = ['docker.io', 'quay.io', 'registry.fedoraproject.org']
   ```

3. Save and close the file. In `vim`, you can save and exit by pressing `ESC` to enter command mode, then type `:wq` and press `ENTER`.

## Step 11: Install Hasura CLI Using the Official Script

1. Download and install the Hasura CLI:

   ```bash
   curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash
   ```

2. Verify the installation:

   ```bash
   hasura version
   ```

## Step 12: Resolve Common Issues

### Issue 1: `slirp4netns` and `dbus-launch` Error

If you encounter the error `failed to move the rootless netns slirp4netns process to the systemd user.slice`, it indicates that `dbus-launch` is not found in your `$PATH`. Install the `dbus` package to resolve this:

```bash
sudo apt install dbus -y
```

### Issue 2: Exposing Privileged Ports 80 and 443

By default, rootless Podman cannot bind to ports below 1024. You can allow rootless users to bind to ports 80 and 443 by modifying `net.ipv4.ip_unprivileged_port_start`:

1. Edit the `/etc/sysctl.conf` file:

   ```bash
   sudo vim /etc/sysctl.conf
   ```

2. Add the following line to the file:

   ```plaintext
   net.ipv4.ip_unprivileged_port_start=80
   ```

3. Save and close the file. Then, apply the change:

   ```bash
   sudo sysctl -p
   ```

4. Install necessary dependencies:

   ```bash
   sudo apt install slirp4netns -y
   ```

5. Enable linger for your user:

   ```bash
   sudo loginctl enable-linger $USER
   ```

6. Enable and start the `podman` service for your user:

   ```bash
   systemctl --user enable podman
   systemctl --user start podman
   ```

7. Restart your system to ensure all changes take effect.

## Summary

You have now set up Podman Compose on your Debian system, configured your environment to automatically activate the Podman virtual environment every time you SSH into your server, generated an SSH key, added it to your GitHub account, created a directory in `/etc/` to store the app codebase, pulled code from GitHub, installed NVM along with the latest LTS version of Node.js, and resolved common issues related to Podman.

With these steps, you're all set to run your multi-container applications seamlessly. Happy coding, and may your servers be ever stable!
