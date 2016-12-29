# .profile, run once on login
# (or at start of every (interactive?) shell on OSX)
# environment vars, process limits
# i.e. stuff inherited by child processes

# Prefix to PATH ###############################
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/opt/config/bin" ] ; then
    PATH="$HOME/opt/config/bin:$PATH"
fi

if [ $OSTYPE = darwin* ] ; then
    # this already in PATH, but we want it before /usr/bin so things like
    # brew can override builtin binaries
    PATH="/usr/local/bin:$PATH"

    # utils from homebrew
    PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
    MANPATH="$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"
fi

export PATH
export MANPATH

# Other env variables ######################


# These completion tuning parameters change the default behavior of
# bash_completion:
# Define to avoid stripping description in --option=description of
# './configure --help'
COMP_CONFIGURE_HINTS=1
# Define to avoid flattening internal contents of tar files
COMP_TAR_INTERNAL_PATHS=1


CPPFLAGS="-I/usr/local/include"
export CPPFLAGS

if [[ -z $TMUX ]]; then
    # added by Miniconda3 3.19.0 installer
    export PATH="$PATH:/Users/csaba/anaconda/bin"
fi

# source .bashrc if we're running Bash
# Is reqd on OSX. Not reqd on Ubuntu.
if [[ "$OSTYPE" == darwin* ]] ; then
  if [ -n "$BASH_VERSION" ]; then
      if [ -f "$HOME/.bashrc" ]; then
          source "$HOME/.bashrc"
      fi
  fi
fi

if [ -a "$HOME/.profile_local" ]; then
    . $HOME/.profile_local
fi
