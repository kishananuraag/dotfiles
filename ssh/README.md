# SSH Setup Guide

This guide helps you set up SSH keys for secure authentication with GitHub and other services.

## Quick Setup for GitHub

### 1. Generate SSH Key

```bash
# Generate a new ED25519 SSH key (recommended)
ssh-keygen -t ed25519 -C "kishananuraag@gmail.com"

# When prompted:
# - File location: Press Enter (accepts default ~/.ssh/id_ed25519)
# - Passphrase: Enter a secure passphrase or leave empty
```

### 2. Add Key to SSH Agent

```bash
# Start ssh-agent
eval "$(ssh-agent -s)"

# Add your SSH key to the agent
ssh-add ~/.ssh/id_ed25519
```

### 3. Copy Public Key

```bash
# Copy public key to clipboard
# macOS:
pbcopy < ~/.ssh/id_ed25519.pub

# Linux/WSL:
cat ~/.ssh/id_ed25519.pub
# Then manually copy the output
```

### 4. Add Key to GitHub

1. Go to https://github.com/settings/keys
2. Click **"New SSH key"**
3. **Title**: Give it a name (e.g., "macOS laptop", "WSL Ubuntu")
4. **Key**: Paste your public key
5. Click **"Add SSH key"**

### 5. Test Connection

```bash
# Test SSH connection to GitHub
ssh -T git@github.com

# You should see:
# Hi kishananuraag! You've successfully authenticated, but GitHub does not provide shell access.
```

## SSH Configuration

### Setup Config File

```bash
# Copy the template to your SSH directory
cp ~/.dotfiles/ssh/config.example ~/.ssh/config

# Set proper permissions
chmod 600 ~/.ssh/config

# Edit the file to customize for your needs
vim ~/.ssh/config
```

### Configuration Features

The provided SSH config includes:

- **Keep-alive settings** - Prevents connection timeouts
- **GitHub/GitLab setup** - Ready-to-use configurations
- **Server examples** - Templates for your servers
- **Security settings** - Best practices

## Advanced Setup

### Multiple SSH Keys

If you need different keys for different services:

```bash
# Generate additional keys
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_work -C "work@company.com"
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_personal -C "personal@email.com"

# Add to SSH agent
ssh-add ~/.ssh/id_ed25519_work
ssh-add ~/.ssh/id_ed25519_personal
```

Then update `~/.ssh/config`:

```ssh
Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work

Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
```

### WSL-Specific Setup

In WSL, you might want to share SSH keys with Windows:

```bash
# Copy SSH keys from Windows (if they exist)
cp /mnt/c/Users/YourUsername/.ssh/* ~/.ssh/
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
```

## Security Best Practices

### 1. Use Strong Passphrases

- Always use a passphrase for your SSH keys
- Use a password manager to generate and store passphrases

### 2. Regular Key Rotation

- Generate new SSH keys annually
- Remove old keys from GitHub/services
- Update your SSH config accordingly

### 3. Limit Key Usage

- Use different keys for different purposes (work, personal, servers)
- Use the `IdentitiesOnly yes` option in SSH config

### 4. Monitor Access

- Regularly check SSH key usage in GitHub Settings > SSH and GPG keys
- Remove any keys you don't recognize

## Troubleshooting

### Common Issues

**"Permission denied (publickey)"**
```bash
# Check if key is loaded
ssh-add -l

# If not, add your key
ssh-add ~/.ssh/id_ed25519

# Test connection with verbose output
ssh -vT git@github.com
```

**"Could not open a connection to your authentication agent"**
```bash
# Start ssh-agent
eval "$(ssh-agent -s)"

# Then add your key
ssh-add ~/.ssh/id_ed25519
```

**Wrong permissions**
```bash
# Fix SSH directory permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
```

### Debug Mode

Use verbose SSH to debug connection issues:

```bash
# Verbose SSH connection
ssh -vvv git@github.com

# Test with specific config
ssh -vvv -F ~/.ssh/config git@github.com
```

## Useful Commands

```bash
# List loaded SSH keys
ssh-add -l

# Remove all keys from agent
ssh-add -D

# List all files in SSH directory
ls -la ~/.ssh/

# View public key
cat ~/.ssh/id_ed25519.pub

# Check SSH config syntax
ssh -F ~/.ssh/config -T git@github.com
```

## Additional Resources

- [GitHub SSH Documentation](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [SSH.com Key Management](https://www.ssh.com/academy/ssh/key)
- [OpenSSH Manual](https://man.openbsd.org/ssh_config)