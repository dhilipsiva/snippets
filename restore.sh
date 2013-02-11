#! /bin/bash

echo 'pullin files'
git pull origin master

echo 'copying dotfiles'
cp -rf . ~/
