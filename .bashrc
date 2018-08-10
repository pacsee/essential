# .bashrc, run by every non-login bash

# . ~/opt/config/bash/prompt.bash
. ~/opt/config/bash/unused.bash
. ~/opt/config/bash/grep-functions.bash
. ~/opt/config/bash/python-functions.bash
. ~/opt/config/bash/nodejs.bash
. ~/opt/config/bash/git-functions.bash
. ~/opt/config/bash/git-completion.bash
. ~/opt/config/bash/virtualisation.bash
. ~/opt/config/bash/ssh.bash
. ~/opt/config/bash/aliases.bash
. ~/opt/config/bash/config.bash

if [ $TERM != 'dumb' ]; then

    if [ -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]; then
        GIT_PROMPT_THEME=Default
        GIT_PROMPT_FETCH_REMOTE_STATUS=0
        source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
    fi

fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
