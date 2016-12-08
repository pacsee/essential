_complete_ssh_hosts ()
{
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
                        cut -f 1 -d ' ' | \
                        sed -e s/,.*//g | \
                        grep -v ^# | \
                        uniq | \
                        grep -v "\[" ;
                cat ~/.ssh/config | \
                        grep "^Host " | \
                        awk '{print $2}'
                `
        COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
        return 0
}
complete -F _complete_ssh_hosts ssh


ec2q () {
    aws ec2 describe-instances \
        --query 'Reservations[].Instances[].[Tags[?Key==`Name`] | [0].Value, ImageId,InstanceId,PrivateIpAddress,PublicIpAddress]' \
        --output text \
        --profile "$1" | grep "$2"
}


flush-dns-cache () {
    sudo killall -HUP mDNSResponder
}

update-time () {
    sudo ntpdate -u time.euro.apple.com
}
