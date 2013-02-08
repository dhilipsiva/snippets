export PS1='\[\033[4;32m\]\A\[\033[0;0m\]\[\033[4;35m\] \W \[\033[4;36m\]->\[\033[0m\] '
alias ls="ls -G"
export LSCOLORS=dxfxcxdxbxegedabagacad

# Setting PATH for Python 2.7
# The orginal version is saved in .bash_profile.pysave
PATH="/usr/local/share/npm/bin:/usr/local/bin:/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
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

# My private bash scripts that I do not want to put on git hub. Top Secret :P
. bash_secret.sh

# A shortcut to open the current branch of the remote in browser. GitHub Helper 
function gh { 
    URL=`git remote show origin | grep Fetch\ URL | sed 's/Fetch URL: //' | sed 's/ //g' | sed 's/\.git//'`
    BRANCH=`git rev-parse --abbrev-ref HEAD`
    open "$URL/tree/$BRANCH"
}

# A python test environment to play expriment something.
function _test {
    deactivate
    . ~/ENV/test/bin/activate
    pip freeze > ~/test-env-requirements.txt
}

# Synchronize. pull and push are defined in `bash_secret.sh`
alias syn="pull && push && gh"

# Set of essential libraries to install in a new virtualenv
function _install_py_musthaves {
    curl https://gist.github.com/gists/4176838/download | pip install
}

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Shortcut to google search from commandline. Handy, huh?
function google {
    open "https://google.com/search?q=$*"
}

function _hello {
 echo hello
}

# Homebrew setting
export PATH="/usr/local/sbin:$PATH"
