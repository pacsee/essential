
" toggle relative line-numbers
function! s:ToggleRelativeLineNumbers()
    if(&rnu == 1)
        windo set nu
    else
        windo set rnu
    endif
endfunc 

nnoremap <Leader>0 :call <SID>ToggleRelativeLineNumbers()<cr>

