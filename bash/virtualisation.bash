export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2.7
export WORKON_HOME=$HOME/.envs
export PROJECT_HOME=$HOME/work
source /usr/local/bin/virtualenvwrapper.sh

function vbox-list {
    VBoxManage list vms
}

function vbox-running {
    VBoxManage list runningvms
}

eval $(docker-machine env default)
if [  "$DOCKER_HOST" != "" ]; then
    export PGHOST=$(echo | awk -v d="$DOCKER_HOST" '{print substr(d,7,length(d)-11) }')
fi
