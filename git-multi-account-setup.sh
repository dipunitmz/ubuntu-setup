#!/bin/bash
# --------------------------------------------
# GUIDE: Git push to private repo using multiple GitHub accounts
# This file is NOT meant to be executed directly.
# It is a step-by-step checklist.
# --------------------------------------------

# 1. Check if repo exists and remote is correct
#   - open https://github.com/<username>/<repo>
#   - make sure the repo exists and you have access

# 2. If repo is private, HTTPS will fail without PAT.
#   You can use SSH instead (recommended).

# 3. Check current remote URL
#   git remote -v

# 4. If you want multiple GitHub accounts:
#   - Create two SSH keys (one for each account)
#   - Add each key to its GitHub account
#   - Configure ~/.ssh/config to use different hosts

# --------------------------------------------
# Create a new SSH key for second GitHub account
# --------------------------------------------
# Run:
# ssh-keygen -t ed25519 -C "adityanitmz"
# When asked for file name, use:
# /home/<user>/.ssh/adityaa_ssh
# (do NOT overwrite the existing id_ed25519 key)

# --------------------------------------------
# Move key files to ~/.ssh (if created in wrong folder)
# --------------------------------------------
# If you created the key inside a project folder, move it:
# mv ~/your-project-folder/adityaa_ssh* ~/.ssh/

# --------------------------------------------
# Add new public key to GitHub account (adityanitmz)
# --------------------------------------------
# Copy the key:
# cat ~/.ssh/adityaa_ssh.pub
# Then add it to:
# GitHub -> Settings -> SSH and GPG keys -> New SSH key

# --------------------------------------------
# Create / edit SSH config file
# --------------------------------------------
# nano ~/.ssh/config
# Add this exact content:

# Host github.com
#   HostName github.com
#   User git
#   IdentityFile ~/.ssh/id_ed25519
#   IdentitiesOnly yes

# Host github-aditya
#   HostName github.com
#   User git
#   IdentityFile ~/.ssh/adityaa_ssh
#   IdentitiesOnly yes

# --------------------------------------------
# Fix permissions (important)
# --------------------------------------------
# chmod 600 ~/.ssh/config
# chmod 600 ~/.ssh/adityaa_ssh
# chmod 600 ~/.ssh/adityaa_ssh.pub

# --------------------------------------------
# Start SSH agent and add keys
# --------------------------------------------
# eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/id_ed25519
# ssh-add ~/.ssh/adityaa_ssh

# --------------------------------------------
# Verify SSH login for both accounts
# --------------------------------------------
# For default account:
# ssh -T git@github.com
# Expected: Hi <default-account>!

# For adityanitmz account:
# ssh -T git@github-aditya
# Expected: Hi adityanitmz!

# --------------------------------------------
# Set remote URL for repo using adityanitmz
# --------------------------------------------
# cd your-repo-folder
# git remote set-url origin git@github-aditya:adityanitmz/temp.git

# Verify remote:
# git remote -v

# --------------------------------------------
# Push to GitHub
# --------------------------------------------
# git push -u origin main

# --------------------------------------------
# If push fails:
# Run debug:
# ssh -vT git@github-aditya
# Check if it offers /home/<user>/.ssh/adityaa_ssh
# If not, config is wrong or key not added to GitHub.

# --------------------------------------------
# End of guide
# --------------------------------------------
