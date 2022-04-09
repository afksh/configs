#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "make sure to add homebrew path to PATH variable"

# Install Zinit
sh -c "$(curl -fsSL https://git.io/zinit-install)"


########## Variables

# dotfiles directory
dir=$(pwd)/config-files

# old dotfiles backup directory
olddir=~/.backup

# list of files/folders to symlink in homedir
files="./config-files"

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $(ls $files); do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file $olddir
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

sudo chsh -s /bin/zsh
/bin/zsh
