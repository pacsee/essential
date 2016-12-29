alias cp='cp -i'
alias df='df -h'
alias du='du -h'
alias ls='ls $LS_OPTIONS'
#alias ll='ls $LS_OPTIONS -lG'
alias ll='gls -lAFh --color=always'
alias l='gls -lFh --color=always'
alias la='gls $LS_OPTIONS -lGa'
alias mv='mv -i'
alias rm='rm -i'
alias less='less -R' # display raw control characters for colors only
alias histread='history -c; history -r'


# if colordiff is installed, use it
if type colordiff &>/dev/null ; then
    alias diff=colordiff
fi

if ! hash gls 2>/dev/null; then
    alias gls='ls --group-directories-first -G'
else
    alias gls='gls --group-directories-first -G'
fi

alias ec='emacs -nw'
