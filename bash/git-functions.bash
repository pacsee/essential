# git stuff
function glog {
    git log --graph --all --format=format:"%x09%C(yellow)%h%C(reset) %C(green)%ai%x08%x08%x08%x08%x08%x08%C(reset) %C(bold white)%cn%C(reset)%C(auto)%d%C(reset)%n%x09%C(white)%s%C(reset)" --abbrev-commit "$@"
    echo
}
function gpp {
    git pull && git push
}
function gtags {
    # list tags at current commit
    git log -n1 --pretty=format:%C\(auto\)%d | sed 's/, /\n/g' | grep tag | sed 's/tag: \|)//g'
}
function gsg {
    GREP=$1
    shift
    git show $@ $(git log --grep $GREP | grep "commit" | cut -d" " -f 2)
}

. ~/.git-completion.bash

