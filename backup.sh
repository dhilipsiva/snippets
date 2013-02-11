#! /bin/bash

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
git commit -m 'Backup #4'

echo 'pushing to origin...'
git push origin master
