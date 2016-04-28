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
  _DATE="\e[1;37m\$(date '+%H:%M:%S')$_RESET"

  . ~/.ps1_vcs

  running_jobs="
    J=\$(jobs -l)
    if [ -n \"\$J\" ]; then
        jobs -l
        echo \"\n\"
    fi
  "

  export PS1="$_USER@$_HOST:$_PWD\$(${dvcs_function}) [$_DATE]\n$_PROMPT "
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


