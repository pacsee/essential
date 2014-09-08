set statusline=

" filename, relative to cwd
set statusline+=%f
set statusline+=\ 

" modified flag
set statusline+=%#lCursor#
set statusline+=%M
set statusline+=%*
set statusline+=\ 

"Display a warning if file encoding isnt utf-8
set statusline+=%#question#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

"display a warning if fileformat isnt unix
set statusline+=%#directory#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if files contains tab chars
set statusline+=%#warningmsg#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

" read-only
set statusline+=%r
set statusline+=%*

" right-align
set statusline+=%=

" filetype
set statusline+=%{strlen(&ft)?&ft:'none'}
set statusline+=\ 

" current char
set statusline+=%3b,0x%02B
set statusline+=\ 

" column,
set statusline+=%2c,
" current line / lines in file
set statusline+=%l/%L

" return '[tabs]' if tab chars in file, or empty string
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('\t', 'nw') != 0

        if tabs
            let b:statusline_tab_warning = '[tabs]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction
"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

