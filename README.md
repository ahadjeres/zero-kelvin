# Setting Up Podman Compose on Debian Instance

This tutorial will guide you through the process of setting up Podman Compose on a Debian instance, including steps to ensure the virtual environment is activated every time you SSH into your server. Additionally, it will cover generating an SSH key to pull code from GitHub, creating a directory in `/etc/` to store the app codebase, and installing NVM for Node.js.

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

1. Open the `~/.zshrc` file in a text editor:

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

## Summary

You have now set up Podman Compose on your Debian system, configured your environment to automatically activate the Podman virtual environment every time you SSH into your server, generated an SSH key, added it to your GitHub account, created a directory in `/etc/` to store the app codebase, pulled code from GitHub, and installed NVM along with the latest LTS version of Node.js.
