#!/bin/bash
############################
# setup.sh
# Sets up dotfiles, symlinks, and auto-sync for the configs repo.
############################

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

confirm() {
    read -p "$1 (y/n): " ans
    [ "$ans" = "y" ]
}

# Install Homebrew
if command -v brew &>/dev/null; then
    echo "Homebrew already installed, skipping."
elif confirm "Install Homebrew?"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Detect brew binary (Apple Silicon: /opt/homebrew, Intel: /usr/local)
    BREW_BIN=""
    for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        [ -x "$candidate" ] && BREW_BIN="$candidate" && break
    done

    if [ -n "$BREW_BIN" ]; then
        SHELLENV_LINE="eval \"\$(${BREW_BIN} shellenv)\""
        if ! grep -qF "$SHELLENV_LINE" ~/.zprofile 2>/dev/null; then
            echo "$SHELLENV_LINE" >> ~/.zprofile
            echo "Added Homebrew to PATH in ~/.zprofile."
        fi
        eval "$($BREW_BIN shellenv)"
    fi
fi

# Install Zinit
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ -d "$ZINIT_HOME" ]; then
    echo "Zinit already installed, skipping."
elif confirm "Install Zinit?"; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
fi


########## Symlinks

dir="$REPO_DIR/config-files"
olddir="$HOME/.backup"

# Files in config-files/ to skip (not meant to be dotfiles)
SKIP_FILES=("AGENTS.md" "README.md")

should_skip() {
    local f="$1"
    for skip in "${SKIP_FILES[@]}"; do
        [ "$f" = "$skip" ] && return 0
    done
    return 1
}

echo ""
echo "=== Dotfile symlinks ==="
echo ""
echo "This will back up existing dotfiles to $olddir and create symlinks from ~ to $dir."
echo ""

if confirm "Proceed with symlink setup?"; then
    mkdir -p "$olddir"
    for filepath in "$dir"/*; do
        file="$(basename "$filepath")"
        if should_skip "$file"; then
            echo "Skipping $file (not a dotfile)."
            continue
        fi
        echo "Moving ~/.$file to $olddir and creating symlink."
        mv ~/."$file" "$olddir" 2>/dev/null || true
        ln -sf "$filepath" ~/."$file"
    done
    echo "Symlinks created."
else
    echo "Skipping symlink setup."
fi


########## Default shell

echo ""
if confirm "Set default shell to zsh?"; then
    chsh -s /bin/zsh
fi


########## SSH & Auto-sync setup

REPO="git@github.com:afksh/configs.git"
GITHUB_USER="afksh"
MAX_ATTEMPTS=10

echo ""
echo "=== Auto-sync setup ==="
echo ""

if ! confirm "Set up hourly auto-sync of this repo to GitHub?"; then
    echo "Skipping auto-sync setup."
    echo ""
    echo "Setup complete. Restart your shell to apply changes."
    exit 0
fi

# Find SSH key or offer to generate one
find_ssh_pubkey() {
    for key in ~/.ssh/id_ed25519.pub ~/.ssh/id_rsa.pub ~/.ssh/id_ecdsa.pub; do
        [ -f "$key" ] && echo "$key" && return 0
    done
    return 0
}

PUBKEY_FILE="$(find_ssh_pubkey)"

if [ -z "$PUBKEY_FILE" ]; then
    echo "No SSH key found on this machine."
    if confirm "Generate a new ed25519 SSH key? (will be created without a passphrase)"; then
        ssh-keygen -t ed25519 -C "$(hostname)" -f ~/.ssh/id_ed25519 -N ""
        PUBKEY_FILE=~/.ssh/id_ed25519.pub
    else
        echo "No SSH key available. Skipping auto-sync setup."
        echo ""
        echo "Setup complete. Restart your shell to apply changes."
        exit 0
    fi
fi

echo ""
echo "Your SSH public key:"
echo ""
cat "$PUBKEY_FILE"
echo ""
echo "Add this key to GitHub with write access to afksh/configs:"
echo "  https://github.com/settings/ssh/new"
echo ""

# Switch remote to SSH so sync.sh can push without credential prompts
git -C "$REPO_DIR" remote set-url origin "$REPO"

# Test SSH auth and write access in a loop
attempt=0
while [ $attempt -lt $MAX_ATTEMPTS ]; do
    input=""
    read -p "Press Enter once you've added the key, or type 'skip' to skip auto-sync setup: " input || true
    if [ "$input" = "skip" ]; then
        echo "Skipping auto-sync setup."
        break
    fi

    echo "Testing SSH authentication with GitHub..."
    if ! ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "SSH key not recognized by GitHub yet. Please make sure you've added it."
        attempt=$(( attempt + 1 )) || true
        [ $attempt -eq $MAX_ATTEMPTS ] && echo "Max attempts reached. Skipping auto-sync setup." && break
        continue
    fi

    echo "Testing write access to repo..."
    if git -C "$REPO_DIR" push --dry-run origin main > /dev/null 2>&1; then
        echo "Write access confirmed."
        echo ""

        GITHUB_ID=$(curl -s "https://api.github.com/users/$GITHUB_USER" | python3 -c "import json,sys; print(json.load(sys.stdin)['id'])")
        NOREPLY_EMAIL="${GITHUB_ID}+${GITHUB_USER}@users.noreply.github.com"
        if confirm "Set git email to $NOREPLY_EMAIL to avoid GitHub email privacy blocks?"; then
            git -C "$REPO_DIR" config user.email "$NOREPLY_EMAIL"
            echo "Git email updated."
        fi

        echo ""
        SYNC_SCRIPT="$REPO_DIR/sync.sh"
        CRON_JOB="0 * * * * $SYNC_SCRIPT"
        echo "This will add the following cron job:"
        echo "  $CRON_JOB"
        echo ""
        if confirm "Add this cron job?"; then
            (crontab -l 2>/dev/null || true; echo "$CRON_JOB") | crontab -
            echo "Cron job added."
        else
            echo "Skipping cron job."
        fi

        break
    else
        echo "Write access denied. Make sure the key has write access to afksh/configs."
        attempt=$(( attempt + 1 )) || true
        [ $attempt -eq $MAX_ATTEMPTS ] && echo "Max attempts reached. Skipping auto-sync setup." && break
    fi
done

echo ""
echo "Setup complete. Restart your shell to apply changes."
