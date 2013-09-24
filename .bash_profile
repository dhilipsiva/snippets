#exports
export LANG="en_US.UTF-8"
export PS1='\[\033[4;35m\] \W \[\033[4;36m\]->\[\033[0m\] '
export LSCOLORS=dxfxcxdxbxegedabagacad
export PATH="/usr/local/sbin:/usr/local/bin:/usr/local/heroku/bin:/usr/local/cuda/bin:$PATH"
export CUDA_ROOT="/usr/local/cuda/bin"

#aliases
alias q="exit"
alias blah="echo 'Blah Blah Blah'"
alias p="python"
alias rs="./manage.py runserver 0.0.0.0:8000"
alias t='date "+ TIME: %H:%M%n DATE: %d %a, %b(%m)"'
alias ds="python manage.py shell -i bpython"
alias ls="ls -G"
alias add="git add --all ."
alias st="git status"
alias es="elasticsearch -f"
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

# A python test environment to play expriment something.
function @test {
    deactivate
    . ~/ENV/test/bin/activate
    pip freeze > ~/test-env-requirements.txt
    cd ~/WIP/test
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

# Set of essential libraries to install in a new virtualenv
function @install_py_musthaves {
    curl https://gist.github.com/gists/4176838/download | pip install
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

function @backup {
    @misc_code_snippets
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


# Edit commit history. WARNING: This is destructive in nature.
function @commitcleanup {
    git filter-branch --env-filter '
        an="$GIT_AUTHOR_NAME"
        am="$GIT_AUTHOR_EMAIL"
        cn="$GIT_COMMITTER_NAME"
        cm="$GIT_COMMITTER_EMAIL"

        if [ "$GIT_COMMITTER_EMAIL" = "dhilipsiva@gmail.com" ]
        then
            cn="dhilipsiva"
            cm="dhilipsiva@gmail.com"
        fi

        if [ "$GIT_AUTHOR_EMAIL" = "dhilipsiva@gmail.com" ]
        then
            an="dhilipsiva"
            am="dhilipsiva@gmail.com"
        fi

        export GIT_AUTHOR_NAME="$an"
        export GIT_AUTHOR_EMAIL="$am"
        export GIT_COMMITTER_NAME="$cn"
        export GIT_COMMITTER_EMAIL="$cm"
    '
}

# open Dash docs
function @dash {
    open "dash://$*"
}

function @pycon {
    . ~/ENV/pycon/bin/activate
    cd ~/WIP/pycon
    pip freeze > requirements.txt
}


# json-to-html
function @json-to-html {
    . ~/ENV/json-to-html/bin/activate
    cd ~/WIP/json-to-html
    pip freeze > requirements.txt
}

function @ml {
    deactivate
    . ~/ENV/ml/bin/activate
    cd ~/WIP/ml
    pip freeze > requirements.txt
}

function @bangpypers {
    . ~/ENV/bangpypers/bin/activate
    cd ~/WIP/bangpypers
    pip freeze > requirements.txt
}

# irc email bridge
# https://github.com/dhilipsiva/irc-email-bridge
function @ieb {
    deactivate
    . ~/ENV/ieb/bin/activate
    cd ~/WIP/ieb
    pip freeze > requirements.txt
}

function @br {
    echo "BRANCH: $(git rev-parse --abbrev-ref HEAD)"
}

function @mail {
    if [[ $1 = "ly" ]]; then
        rvm use current && vmail -c ~/.vmailrc-ly
    else
        rvm use current && vmail
    fi
}

# function to download youtube video
function @yt {
    youtube-dl --max-quality mp4 $*
}

function @nave {
    nave use 0.10.15
}

function search {
    grep -irl --exclude=\*.{pyc,swp,un~,png,jpg} --exclude-dir=".git" --color "$*" .
}
