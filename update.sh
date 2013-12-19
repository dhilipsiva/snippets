#! /bin/bash
#
# update.sh
# Copyright (C) 2013 dhilipsiva <dhilipsiva@gmail.com>
#
# Distributed under terms of the MIT license.
#


brew update
brew upgrade
cd .vim && make
