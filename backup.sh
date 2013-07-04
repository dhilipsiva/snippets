#! /bin/bash

# Get environment variables
. ~/.bash_profile

set -e

echo 'copying bash_profile...'
cp -f ~/.bash_profile ./

echo 'copying gitconfig...'
cp -f ~/.gitconfig ./

echo 'copying vimrc...'
cp -f ~/.vimrc ./

echo 'copying gitignore_global...'
cp -f ~/.gitignore_global ./

echo 'adding files to git...'
@add

echo 'commiting changes if any...'
read -p "Commit Message: " msg
echo $msg 
if [ "$msg" = "" ]; then
    msg="Backup #4"
else
    msg="$msg #4"
fi
echo $msg
@commit "$msg"

echo 'syncing with remote'
@pull
@push
