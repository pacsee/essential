# .bashrc, run by every non-login bash
# aliases and transient shell options that are not inherited by child processes

#----------------------------------------
# environment vars related to interactive command-line use

export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

# PS1
case $- in

# interactive shell
*i*)
  _PRE='\[\e['
  _POST='m\]'

  _DIM_CYAN="${_PRE}36${_POST}"
  _BRIGHT_CYAN="${_PRE}36;01${_POST}"
  _RESET="${_PRE}00${_POST}"

  _USER="$_DIM_CYAN\u$_RESET"
  _HOST="$_DIM_CYAN\h$_RESET"
  _PWD="$_DIM_CYAN\w$_RESET"
  _PROMPT="$_BRIGHT_CYAN\$$_RESET"

  . ~/.ps1_vcs

  export PS1="$_USER@$_HOST:$_PWD\$(${dvcs_function})\n$_PROMPT "
  unset _PRE _POST _DIM_CYAN _BRIGHT_CYAN _RESET _USER _HOST _PWD _PROMPT

  # Whenever displaying the prompt, append history to disk
  PROMPT_COMMAND='history -a'

  # display red exit value if it isn't zero
  PROMPT_COMMAND='EXITVAL=$?; '$PROMPT_COMMAND
  GET_EXITVAL='$(if [[ $EXITVAL != 0 ]]; then echo -n "\[\e[37;41;01m\] $EXITVAL \[\e[0m\] "; fi)'
  export PS1="$GET_EXITVAL$PS1"

  # turn off flow control, mapped to ctrl-s, so that we regain use of that key
  # for searching command line history forwards (opposite of ctrl-r)
  stty -ixon

;;

# non-interactive shell
*)
;;

esac


# Other env variables ######################
export EDITOR=vim

export HISTSIZE=100000 # bash history will save this many commands
export HISTFILESIZE=${HISTSIZE} # bash will remember this many commands
export HISTCONTROL=ignoredups # ignore duplicate commands
export HISTIGNORE="[   ]*:&:bg:fg:exit" # Ignore some controlling instructions
export HISTTIMEFORMAT="[%Y-%m-%d - %H:%M:%S] " # timestamps

export LESS=-R
export MAILCHECK
# prevent man pages from displaying bold text in black
export LESS_TERMCAP_md=$'\E[01;36m'
export GREP_COLORS="ms=1;33:fn=32:ln=1;32:se=0;37"

# figure out supported ls options

# nice modern GNU 'ls'
if ls --color >/dev/null 2>&1; then
    LS_OPTIONS='--color=auto'

# old shitty OSX 'ls'
elif ls --G >/dev/null 2>&1; then
    LS_OPTIONS='-G'

# no known color options supported, use trailing filetype chars instead
else
    LS_OPTIONS='-F'
fi

if ls --group-directories-first >/dev/null 2>&1; then
    LS_OPTIONS="$LS_OPTIONS --group-directories-first"
fi
export LS_OPTIONS

if [ "$TERM" != "dumb" ]; then
    eval `dircolors -b $HOME/.dircolors`
fi

#----------------------------------------
# options to coreutils
# Require latest gnu coreutils, probably don't work with Mac's old built-in ones
alias cp='cp -i'
alias df='df -h'
alias du='du -h'
alias ls='ls $LS_OPTIONS'
#alias ll='ls $LS_OPTIONS -lG'
alias ll='gls -lAFh --color=always'
alias la='gls $LS_OPTIONS -lGa'
alias mv='mv -i'
alias rm='rm -i'
alias less='less -R' # display raw control characters for colors only
alias histread='history -c; history -r'

gitl () 
{ 
git log --graph --color --all --format=format:"%x09%C(bold blue)%h%C(reset) %C(bold green)%ai%x08%x08%x08%x08%x08%x08%C(reset) %C(bold white)%cn%C(reset)%C(bold yellow)%d%C(reset)%n%x09%C(white)%s%C(reset)" --abbrev-commit "$@";
echo
}

# recursive search in files
function grp {
    GREP_OPTIONS="-rI --color --exclude-dir=\.bzr --exclude-dir=\.git --exclude-dir=\.hg --exclude-dir=\.svn --exclude=tags $GREP_OPTIONS" grep "$@"
}

# recursive search in Python source
function grpy {
    GREP_OPTIONS="--exclude-dir=build --exclude-dir=dist --include=*.py $GREP_OPTIONS" grp "$@"
}

# recursive search in files, do not follow symlinks
function grpns {
    find . \( -name .git -o -name .bzr -o -name .hg -o -name .svn \) -prune -o -type f -a -exec \
        grep -IHn --color "$@" '{}' \;
}


# if colordiff is installed, use it
if type colordiff &>/dev/null ; then
    alias diff=colordiff
fi

# OSX: show postscript rendered man page in Preview
function pman () {
    # just using builtins (but Preview pops up a conversion dialog)
    # man -t $@ | open -f -a /Applications/Preview.app

    # or convert using ps2pdf, requires "brew install ghostscript"
    man -t $@ | ps2pdf - - | open -f -a /Applications/Preview.app
}

function ppjson () {
    python -mjson.tool $* | colout -s js
}

# OSX: Quit an application from the command line
quit () {
    for app in $*; do
        osascript -e 'quit app "'$app'"'
    done
}

# OSX: Pass 0 or 1 to hide or show hidden files in Finder
function showhidden() {
    defaults write com.apple.Finder AppleShowAllFiles $1
    killall Finder
}


# Change terminal window and tab name
function tabname {
  printf "\e]1;$1\a"
}

function winname {
  printf "\e]2;$1\a"
}


function rm_tags {
    # remove all tags files in dirs under . but skip .git subdirs
    find . -path "./.git" -prune -o -name "tags" -print | xargs rm -f
}
function pytags {
    rm_tags
    ctags -R --languages=python $*
}

# git stuff
function glog {
    git log --graph --all --format=format:"%x09%C(yellow)%h%C(reset) %C(green)%ai%x08%x08%x08%x08%x08%x08%C(reset) %C(bold white)%cn%C(reset)%C(auto)%d%C(reset)%n%x09%C(white)%s%C(reset)" --abbrev-commit "$@"
    echo
}
function gpp {
    git pull && git push
}
function gtags {
    # list tags at current commit
    git log -n1 --pretty=format:%C\(auto\)%d | sed 's/, /\n/g' | grep tag | sed 's/tag: \|)//g'
}

. ~/.git-completion.bash

# hg stuff
alias hgpp='hg pull && hg push'


# linux stuff
alias gnome-terminal='gnome-terminal --geometry=80x50'

alias whence='type -a'    # where, of a sort

alias py32="arch -i386 python"

alias gvimall="find . -type f -and -not -name '*.pyc' -and -not -name '__init__.py' | xargs gvim"


# Shell Options (See man bash)

# Don't wait for job termination notification
set -o notify

# Don't use ^D to exit
#set -o ignoreeof


# Use case-insensitive filename globbing
# shopt -s nocaseglob

# prevent redirected output from overwriting existing files
# set -o noclobber

# Make bash append rather than overwrite the history on disk
shopt -s histappend

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# save multi-line commands as a single line in the history.
shopt -s cmdhist
# and use newlines to separate rather than semi-colons
shopt -s lithist

# don't autocomplete if command-line is empty
shopt -s no_empty_cmd_completion

# virtualenvwrapper
#export WORKON_HOME="~/.envs"
#if [ "$HOSTNAME" == "jhlin" ]; then
#    export VIRTUALENVWRAPPER_PYTHON=python2.6
#else
#    export VIRTUALENVWRAPPER_PYTHON=python3.4
#fi
#source virtualenvwrapper.sh

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

#export PATH=/home/pcsaba/bin/Sencha/Cmd/5.0.0.160:$PATH
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.3/bin
export SENCHA_CMD_3_0_0="/home/pcsaba/bin/Sencha/Cmd/5.0.0.160"
