#! /bin/bash

# Get environment variables
. ~/.bash_profile

echo 'copying bash_profile...'
cp -f ~/.bash_profile ./

echo 'copying gitconfig...'
cp -f ~/.gitconfig ./

echo 'copying vimrc...'
cp -f ~/.vimrc ./

echo 'copying gitignore_global...'
cp -f ~/.gitignore_global ./

echo 'adding files to git...'
git add .

echo 'commiting changes if any...'
@commit "Backup #4"

echo 'syncing with remote'
syn
