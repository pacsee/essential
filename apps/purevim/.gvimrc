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


if has('win32') || has('win64')
    set guifont=DejaVu\ Sans\ Mono:h9
elseif has('mac')
    set guifont=Monaco:h12
    " set guifont=xos4\ Terminus\ 9 " OSX?
elseif has('unix')
    " set guifont=Terminus\ 9 " Ubuntu.
    set guifont=Dina\ 8 " Ubuntu. Wider than terminus.
    " set guifont=DejaVu\ Sans\ Mono\ 9 " SuSE.
    " set guifont=Ubuntu\ Mono\ 9 # default. Is anti-aliased. :-(
endif
