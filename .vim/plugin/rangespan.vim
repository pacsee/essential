
function! OpenBrowser()
    let url  = "https://rangespan.codebasehq.com/projects/rangespan/repositories/"
    " assume repo name == basename(pwd)
    " use 'echo -n' to strip trailing \n char from output
    let url .= system('echo -n ${PWD##*/}')

    let url .= "/blob/"

    " branchname
    " use 'echo -n' to strip trailing \n char from output
    let url .= system('echo -n $(git symbolic-ref -q --short HEAD)')

    let url .= "/"

    " filename relative to pwd, which is assumed to be root of repo
    let url .= expand('%')

    " line number
    let url .= "\\#L"
    let url .= line('.')

    execute "!open " . url

endfunction

nnoremap <leader>o :call OpenBrowser()<CR>

