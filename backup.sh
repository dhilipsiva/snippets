#! /bin/bash

echo 'copying bash_profile...'
cp -f ~/.bash_profile dotfiles/

echo 'copying gitconfig...'
cp -f ~/.gitconfig dotfiles/

echo 'copying vimrc...'
cp -f ~/.vimrc dotfiles/

echo 'copying gitignore_global...'
cp -f ~/.gitignore_global dotfiles/

echo 'initializing git...'
git init

echo 'adding files to git...'
git add .

echo 'commiting changes if any...'
git commit -m 'Backup #4'

echo 'pushing to origin...'
git push
