#
# Makefile
# dhilipsiva, 2013-08-26 12:47
#
#
# vim:ft=make
#

all: upgrade_brew update_vim update_misc_code_snippets
	@echo "Finished"

msg:
	@echo "updating dhilipsiva 's system"

upgrade_brew:
	brew update
	brew upgrade

update_vim:
	cd ~/.vim \
		git submodule init \
		git submodule update \
		git submodule foreach --recursive git checkout master \
		git submodule foreach --recursive git pull \
		git add --all . \
		git commit "Auto Update" \
		git push origin master

update_misc_code_snippets:
	cd ~/Desktop/WIP/misc-code-snippets \
		sh backup.sh \
