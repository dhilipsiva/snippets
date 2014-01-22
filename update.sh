#! /bin/bash
#
# update.sh
# Copyright (C) 2013 dhilipsiva <dhilipsiva@gmail.com>
#
# Distributed under terms of the MIT license.
#

gem update
brew update
brew upgrade
brew cleanup
brew prune
cd .vim && make
