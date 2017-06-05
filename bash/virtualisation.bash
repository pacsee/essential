#export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2.7
export WORKON_HOME=$HOME/.envs
export PROJECT_HOME=$HOME/work
#source /usr/local/bin/virtualenvwrapper.sh
source ~/opt/config/workspace/workspace-init.sh

function vbox-list {
    VBoxManage list vms
}

function vbox-running {
    VBoxManage list runningvms
}


function use-docker-machine {
    eval $(docker-machine env default)
    if [  "$DOCKER_HOST" != "" ]; then
        export PGHOST=$(echo | awk -v d="$DOCKER_HOST" '{print substr(d,7,length(d)-11) }')
    fi
}
function use-docker {
    unset DOCKER_TLS_VERIFY
    unset DOCKER_HOST
    unset DOCKER_CERT_PATH
    unset DOCKER_MACHINE_NAME
}

function docker-cleanup {
    docker rmi $(docker images -q -f dangling=true)
    docker volume rm $(docker volume ls -qf dangling=true)
}

function docker-time-update {
    docker run -it --rm --privileged --pid=host debian nsenter -t 1 -m -u -n -i date -u $(date -u +%m%d%H%M%Y)
}
