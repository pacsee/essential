# Shell Options (See man bash)

# Don't wait for job termination notification
set -o notify

# Don't use ^D to exit
#set -o ignoreeof
if [ $TERM != 'dumb' ]; then
    #allow CTRL-s to go trough
    stty -ixon
fi

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
if [ $TERM != 'dumb' ]; then
    export LESS_TERMCAP_md=$'\E[01;36m'
fi

# figure out supported ls options

# nice modern GNU 'ls'
if [ "$TERM" != "dumb" ] && [ ls --color >/dev/null 2>&1] ; then
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

if [ "$TERM" != "dumb" ] && [ hash dircolors 2>/dev/null ]; then
    eval `dircolors -b $HOME/.dircolors`
fi

export PAGER=less

