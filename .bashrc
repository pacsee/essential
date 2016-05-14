# .bashrc, run by every non-login bash

# . ~/opt/config/bash/prompt.bash
. ~/opt/config/bash/unused.bash
. ~/opt/config/bash/grep-functions.bash
. ~/opt/config/bash/python-functions.bash
. ~/opt/config/bash/git-functions.bash
. ~/opt/config/bash/git-completion.bash
. ~/opt/config/bash/virtualisation.bash
. ~/opt/config/bash/ssh.bash
. ~/opt/config/bash/config.bash
. ~/opt/config/bash/aliases.bash

if [ -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]; then
    GIT_PROMPT_THEME=Default
    source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
  fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -a "~/.bashrc_local" ]; then
    . ~/.bashrc_local
fi
