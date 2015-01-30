# .profile, run once on login
# (or at start of every (interactive?) shell on OSX)
# environment vars, process limits
# i.e. stuff inherited by child processes

# BATS stuff ###################################
test -z "$PROFILEREAD" && . /etc/profile || true


# Prefix to PATH ###############################

if [ -d "$HOME/Sencha/Cmd/5.0.0.160" ] ; then
    PATH="$HOME/Sencha/Cmd/5.0.0.160:$PATH"
fi
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
# for BATS, ~/bin already used
if [ -d "$HOME/mybin" ] ; then
    PATH="$HOME/mybin:$PATH"
fi
if [ -d "$HOME/docs/bin" ] ; then
    PATH="$HOME/docs/bin:$PATH"
fi
if [ -d "$HOME/docs/bin/linux" ] ; then
    PATH="$HOME/docs/bin/linux:$PATH"
fi
if [ $OSTYPE = cygwin ] ; then
    if [ -d ~/bin/cygwin ] ; then
        PATH=~/bin/cygwin:"${PATH}"
    fi
    if [ -d ~/docs/bin/cygwin ] ; then
        PATH=~/docs/bin/cygwin:"${PATH}"
    fi
fi

if [ $OSTYPE = darwin* ] ; then
    # this already in PATH, but we want it before /usr/bin so things like
    # brew can override builtin binaries
    PATH="/usr/local/bin:$PATH"

    # utils from homebrew
    PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
    MANPATH="$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"

    # PATH for installed pythons
    PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
    PATH="/Library/Frameworks/Python.framework/Versions/3.3/bin:${PATH}"
fi

export PATH
export MANPATH

# Other env variables ######################

if [ $OSTYPE = cygwin ] ; then
    export PYTHONSTARTUP=$HOME\\.pythonstartup.py
else
    # native Linux shell
    export PYTHONSTARTUP=$HOME/.pythonstartup.py
fi

# These completion tuning parameters change the default behavior of
# bash_completion:
# Define to avoid stripping description in --option=description of
# './configure --help'
COMP_CONFIGURE_HINTS=1
# Define to avoid flattening internal contents of tar files
COMP_TAR_INTERNAL_PATHS=1

 
CPPFLAGS="-I/usr/local/include"
export CPPFLAGS

# source .bashrc if we're running Bash
# Is reqd on OSX. Not reqd on Ubuntu.
if [[ "$OSTYPE" == darwin* ]] ; then
  if [ -n "$BASH_VERSION" ]; then
      if [ -f "$HOME/.bashrc" ]; then
          source "$HOME/.bashrc"
      fi
  fi
fi

# run .bashrc if we're in an interactive shell, e.g. in tmux
case $- in *i*) . ~/.bashrc;; esac

_complete_ssh_hosts ()
{
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
                        cut -f 1 -d ' ' | \
                        sed -e s/,.*//g | \
                        grep -v ^# | \
                        uniq | \
                        grep -v "\[" ;
                cat ~/.ssh/config | \
                        grep "^Host " | \
                        awk '{print $2}'
                `
        COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
        return 0
}
complete -F _complete_ssh_hosts ssh

export PATH=/home/pcsaba/bin/Sencha/Cmd/5.0.0.160:$PATH
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

export SENCHA_CMD_3_0_0="/home/pcsaba/bin/Sencha/Cmd/5.0.0.160"
