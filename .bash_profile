#exports
export LANG="en_US.UTF-8"
export PS1=' \[\033[4;35m\]\W \[\033[4;36m\]->\[\033[0m\] '
export LSCOLORS=dxfxcxdxbxegedabagacad
export PATH="/usr/local/sbin:/usr/local/bin:/usr/local/opt/ruby/bin:$PATH"
export CUDA_ROOT="/usr/local/cuda/bin"

#en_US.UTF-8
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"


#aliases
alias q="exit"
alias blah="echo 'Blah Blah Blah'"
alias p="python"
alias @t='date "+ TIME: %H:%M%n DATE: %d %a, %b(%m)"'
alias ds="./manage.py shell"
alias ls="ls -G"
alias add="git add --all ."
alias st="git status"
alias d="git diff"
alias dc="git diff --cached"

# My private bash scripts that I do not want to put on GitHub. Top Secret :P
. ~/bash_secret.sh

# Functions

function m {
    if [[ $1 = "" ]]; then
        mvim .
    else
        mvim $*
    fi
}

function rs {
    if [[ $1 = "" ]]; then
        ./manage.py runserver 0.0.0.0:8000
    else
        ./manage.py runserver 0.0.0.0:$1
    fi
}

# A python test environment to play expriment something.
function @test {
    . ~/ENV/test/bin/activate
    pip freeze > ~/test-env-requirements.txt
    cd ~/WIP/test
}

function @testf {
    . ~/ENV/testf/bin/activate
    cd ~/WIP/test
}

function @mec-gems {
    # MEC GEMS Presentation
    . ~/ENV/mec-gems/bin/activate
    cd ~/WIP/mec-gems
}

function @pull {
    if [[ $1 = "" ]]; then
        git pull origin $(git rev-parse --abbrev-ref HEAD)
    else
        git pull $1 $(git rev-parse --abbrev-ref HEAD)
    fi
}

function @push {
    if [[ $1 = "" ]]; then
        git push origin $(git rev-parse --abbrev-ref HEAD)
    else
        git push $1 $(git rev-parse --abbrev-ref HEAD)
    fi
}

function @syn {
    @pull $* && @push $*
}

### Added by the Heroku Toolbelt

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Shortcut to google search from commandline. Handy, huh?
function @google {
    open "https://google.com/search?q=$*"
}

function @misc_code_snippets {
    pushd .
    cd ~/WIP/misc-code-snippets
    ./backup.sh
    popd
}

function @commit {
    if [[ $1 = "" ]]; then
        git commit -m "Quick commit"
    else
        git commit -m "$*"
    fi
}

# brew bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# open Dash docs
function @dash {
    open "dash://$*"
}

# irc email bridge
# https://github.com/dhilipsiva/irc-email-bridge
function @ieb {
    . ~/ENV/ieb/bin/activate
    cd ~/WIP/ieb
    pip freeze > requirements.txt
}

function @br {
    echo "BRANCH: $(git rev-parse --abbrev-ref HEAD)"
}

function @nave {
    nave.sh use 0.11.9
}

function search {
    grep -irl --exclude=\*.{pyc,swp,un~,png,jpg} --exclude-dir=".git" --color "$*" .
}

function tc {
    # Just a true caller shortcut
    open "http://www.truecaller.com/in/$*"
}
function irc-ext {
     . ~/ENV/irc-ext/bin/activate
     cd ~/WIP/irc-ext/
}

# Function for my site - dhilipsiva.com
function site {
     . ~/ENV/site/bin/activate
     cd ~/WIP/site/
}
