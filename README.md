# zero-kelvin

Sure! Here's a complete guide in Markdown format.

```markdown
# Installing Podman Compose on Debian and Activating Environment on SSH

## Step 1: Update and Install Necessary Packages

Update the package list and install Podman, Python pip, and the virtual environment package:

```bash
sudo apt update
sudo apt install podman python3-pip python3-venv -y
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

### For Bash Users:

Open the `~/.bashrc` file in a text editor:

```bash
nano ~/.bashrc
```

Add the following line to the end of the file:

```bash
source ~/podman_env/bin/activate
```

Save and close the file. In `nano`, you can save by pressing `CTRL + O`, then press `ENTER` to confirm. Close the editor by pressing `CTRL + X`.

Reload the startup script to apply the changes:

```bash
source ~/.bashrc
```

### For Zsh Users:

Open the `~/.zshrc` file in a text editor:

```bash
nano ~/.zshrc
```

Add the following line to the end of the file:

```bash
source ~/podman_env/bin/activate
```

Save and close the file. In `nano`, you can save by pressing `CTRL + O`, then press `ENTER` to confirm. Close the editor by pressing `CTRL + X`.

Reload the startup script to apply the changes:

```bash
source ~/.zshrc
```

## Summary

You have now installed Podman Compose on your Debian system and configured your environment to automatically activate the Podman virtual environment every time you SSH into your server.

1. **Update and install necessary packages**:

   ```bash
   sudo apt update
   sudo apt install podman python3-pip python3-venv -y
   ```

2. **Create and activate the virtual environment**:

   ```bash
   python3 -m venv ~/podman_env
   source ~/podman_env/bin/activate
   ```

3. **Install Podman Compose**:

   ```bash
   pip install podman-compose
   ```

4. **Add the activation command to the startup script**:

   ```bash
   echo 'source ~/podman_env/bin/activate' >> ~/.bashrc
   source ~/.bashrc
   ```

Now, every time you SSH into your Debian server, your Podman virtual environment will be automatically activated.
```
