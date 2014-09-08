" on OSX
" c-      : ctrl
" a- or m-: alt
" d-      : cmd

set guioptions-=a " autoselect - put selection onto clipboard
set guioptions-=A " autoselect for modeless selection, whatever that means

set guioptions-=c " console dialogs instead of gui
set guioptions+=v " vertical button layout for dialogs

set guioptions-=L " left-hand scrollbar when window vertically split
set guioptions-=r " right-hand scrollbar

set guioptions-=m " menu bar
set guioptions-=T " toolbar

set linespace=0
set noerrorbells
set visualbell
set t_vb=


" highlight current line only in the current window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" highlight 81st column only in the current window
augroup Col80
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal colorcolumn=81
  au WinLeave * setlocal colorcolumn=0
augroup END

" ------------------------------------------------------------------
" Solarized Colorscheme Config
" ------------------------------------------------------------------
let g:solarized_termtrans=0    "default value is 1
let g:solarized_contrast="high"    "default value is normal
let g:solarized_visibility="high"    "default value is normal
set background=dark
colorscheme solarized
" default values:
" let g:solarized_bold=1 | 0
" let g:solarized_degrade=0 | 1
" let g:solarized_diffmode="normal" | "high" | "low"
" let g:solarized_italic=1 | 0
" let g:solarized_hitrail=0 | 1
" let g:solarized_menu=1 | 0
" let g:solarized_termcolors=16 | 256
" let g:solarized_underline=1 | 0

if has('win32') || has('win64')
    set guifont=DejaVu\ Sans\ Mono:h9
elseif has('mac')
    set guifont=Monaco:h10
    " set guifont=xos4\ Terminus\ 9 " OSX?
elseif has('unix')
    " set guifont=Terminus\ 9 " Ubuntu.
    set guifont=Dina\ 8 " Ubuntu. Wider than terminus.
    " set guifont=DejaVu\ Sans\ Mono\ 9 " SuSE.
    " set guifont=Ubuntu\ Mono\ 9 # default. Is anti-aliased. :-(
endif

" increase/decrease font size with - and +

function! FontSmaller()
    if has('win32') || has('win64') || has('mac')
        let &guifont = substitute(&guifont, ':h\(\d\+\)', '\=":h" . (submatch(1) - 1)', '')
    else
        let &guifont = substitute(&guifont, ' \(\d\+\)', '\=" " . (submatch(1) - 1)', '')
    endif
endfunction

function! FontBigger()
    if has('win32') || has('win64') || has('mac')
        let &guifont = substitute(&guifont, ':h\(\d\+\)', '\=":h" . (submatch(1) + 1)', '')
    else
        let &guifont = substitute(&guifont, ' \(\d\+\)', '\=" " . (submatch(1) + 1)', '')
    endif
endfunction

nmap - :call FontSmaller()<cr>:echo &guifont<cr>
nmap = :call FontBigger()<cr>:echo &guifont<cr>

function! MaximizeVertical()
    if has('mac')
        set lines=9999
    else
        set lines=84
    endif
endfunction

set guiheadroom=0
call MaximizeVertical()

if has('mac')
    " single column
    noremap <silent> <m-f1> :set columns=84<cr>:only!<cr>:call MaximizeVertical()<cr>
    map! <silent> <m-f1> <esc><m-f1>a
    " double column
    noremap <silent> <m-f2> :set columns=169<cr>:only!<cr>:vsplit<cr>:call MaximizeVertical()<cr>
    map! <silent> <m-f2> <esc><m-f2>a
    " TRIPLE COLUMN MADNESS!!!
    noremap <silent> <m-f3> :set columns=254<cr>:only!<cr>:vsplit<cr>:vsplit<cr>:call MaximizeVertical()<cr>
    map! <silent> <m-f3> <esc><m-f3>a
else
    " single column
    noremap <silent> <c-f1> :set columns=84<cr>:only!<cr>:call MaximizeVertical()<cr>
    map! <silent> <c-f1> <esc><c-f1>a
    " double column
    noremap <silent> <c-f2> :set columns=169<cr>:only!<cr>:vsplit<cr>:call MaximizeVertical()<cr>
    map! <silent> <c-f2> <esc><c-f2>a
    " TRIPLE COLUMN MADNESS!!!
    noremap <silent> <c-f3> :set columns=254<cr>:only!<cr>:vsplit<cr>:vsplit<cr>:call MaximizeVertical()<cr>
    map! <silent> <c-f3> <esc><c-f3>a
endif

" on OSX, try also ctrl-cms-F fullscreen, and ctrl-cmd-Z maximise vertical
nnoremap <a-F11> :call MaximizeVertical()<CR>

" When gvimrc is edited, reload it
autocmd! bufwritepost .gvimrc source ~/.gvimrc

