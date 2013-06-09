export PS1='\[\033[4;35m\] \W \[\033[4;36m\]->\[\033[0m\] '
export LSCOLORS=dxfxcxdxbxegedabagacad

# Colored `ls` output on mac
alias ls="ls -G"

PATH="/usr/local/bin:${PATH}"
export PATH
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE=C
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"

# My private bash scripts that I do not want to put on GitHub. Top Secret :P
. ~/bash_secret.sh

# A shortcut to open the current branch of the remote in browser. GitHub Helper 
function gh { 
    URL=`git remote show origin | grep Fetch\ URL | sed 's/Fetch URL: //' | sed 's/ //g' | sed 's/\.git//'`
    BRANCH=`git rev-parse --abbrev-ref HEAD`
    open "$URL/tree/$BRANCH"
}

# A python test environment to play expriment something.
function @test {
    deactivate
    . ~/ENV/test/bin/activate
    pip freeze > ~/test-env-requirements.txt
    cd ~/Desktop/WIP/test
}

# Synchronize. pull and push are defined in `bash_secret.sh`
alias syn="pull && push && gh"

# Set of essential libraries to install in a new virtualenv
function @install_py_musthaves {
    curl https://gist.github.com/gists/4176838/download | pip install
}

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Shortcut to google search from commandline. Handy, huh?
function @google {
    open "https://google.com/search?q=$*"
}

function @hello {
 echo hello
}

# Homebrew setting
export PATH="/usr/local/sbin:$PATH"

alias q="exit"

function @misc_code_snippets {
    cd ~/Desktop/WIP/misc-code-snippets
    ./backup.sh
    exit
}

function @commit {
    git commit --signoff -m "$*"
}

# brew bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# A tiny script to Compile the java file and run it if it compiles successfully.
function j {
    javac $1.java && java $1 $2
}

# This is just a shorthand to open the java samples folder.
function @java {
    cd ~/Desktop/WIP/java
}

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

#Blah
function blah {
    echo "Blah Blah Blah"
}

#mvim alias
alias m="mvim"
alias p="python"

# open Dash docs
function dash {
    open "dash://$*"
}

# json-to-html
function json-to-html {
    . ~/ENV/json-to-html/bin/activate
    cd ~/Desktop/WIP/json-to-html
    pip freeze > requirements.txt
}
