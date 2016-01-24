PY=$(which python)
CMD='/Users/csaba/opt/config/workspace/workspace.py'

function workspace() {
    $PY $CMD $@
}

function enter() {
    eval "$($PY $CMD activate $1)"
}

 function _enter()   #  By convention, the function name
{                 #+ starts with an underscore.
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "`workspace ls --completion`" -- ${cur}) )
}
complete -F _enter -o default -o nospace enter
