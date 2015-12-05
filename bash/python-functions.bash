export PYTHONSTARTUP=$HOME/.pythonstartup.py

function ppjson () {
    python -mjson.tool $* | colout -s js
}

function pyclean {
    find . -type f -name "*.py[co]" -delete
    find . -type d -name "__pycache__" -delete
}
function pytags {
    # rm_tags
    ctags -R --languages=python --extra=+f --links=no --python-kinds=-iv $*
}

function webtags {
    ctags -R --extra=+f --links=no --python-kinds=-iv $*
}

function mkvirtualenv3 {
    mkvirtualenv --python=/usr/local/bin/python3 $*
}

function virtualenv3 {
    virtualenv --python=/usr/local/bin/python3 $*
}

