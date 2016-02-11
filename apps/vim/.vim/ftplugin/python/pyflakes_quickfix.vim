
let g:pyflakes_use_quickfix = 0

function! TogglePyflakesQuickfix()
    if g:pyflakes_use_quickfix == 1
        let g:pyflakes_use_quickfix = 0
        if &filetype == "Python"
            silent PyflakesUpdate
        endif
        QuickfixToggle(0)
    else
        if &filetype == "Python"
            let g:pyflakes_use_quickfix = 1
            silent PyflakesUpdate
            QuickfixToggle(1)
        endif
    endif
endfunction

noremap <a-f4> :call TogglePyflakesQuickfix()<cr>

