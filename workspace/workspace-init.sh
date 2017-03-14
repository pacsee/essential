PY=$(which python2)
CMD='/Users/csaba/opt/config/workspace/workspace.py'

function workspace() {
    $PY $CMD $@
}

function enter() {
    eval "$($PY $CMD activate $1)"
}

function wswrap() {
    ws=$1
    shift
    eval "$($PY $CMD wrap $ws)"
    ARGS=$(printf "%q " "$@")
    eval "$ARGS"
}

 function _enter()   #  By convention, the function name
{                 #+ starts with an underscore.
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "`workspace ls --completion`" -- ${cur}) )
}
complete -F _enter -o default -o nospace enter
