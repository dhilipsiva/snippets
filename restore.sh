#! /bin/bash
echo 'initializing git...'
git init

echo 'pullin files'
git pull

echo 'copying dotfiles'
cp -rf dotfiles/ ~/
