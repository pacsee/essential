" Jonathan Hartley, tartley@tartley.com



" Don't be compatible with original vi. Must be first, changes other settings
set nocompatible

" mouse and keyboard selections enter visual mode, not select mode
set selectmode=

" right mouse button extends selection instead of context menu
set mousemodel=extend

" shift plus movement keys changes selection
set keymodel=startsel,stopsel

" allow cursor to be positioned one char past end of line
" and apply operations to all of selection including last char
set selection=exclusive

" allow backgrounding buffers without writing them
" and remember marks/undo for backgrounded buffers
set hidden

" Keep more context when scrolling off the end of a buffer
set scrolloff=3

" Make searches case-sensitive only if they contain upper-case characters
set noignorecase
set smartcase
" show search matches as the search pattern is typed
set incsearch

" don't flick the cursor to show matching brackets, they are already highlighted
set noshowmatch

" highlight last search matches
set hlsearch
" ctl-l doesn't just refresh window, but also hides search highlights
nnoremap <silent> <c-l> :nohlsearch<cr><c-l>
inoremap <silent> <c-l> :nohlsearch<cr><c-l>

" search-next wraps back to start of file
set wrapscan

" make tab completion for files/buffers act like bash
set wildmenu
set wildmode=list:longest
" stuff to ignore when autocompleting filenames
set wildignore=*.pyc,*.pyo

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" create backup dir if it doesn't exist
" invoke via 'system' so the new cmd shell on Windows is minimised
" invoke via 'bash -c' so that 'mkdir' always applies to cygwin executable,
" not the cmd shell builtin, which doesn't support ~ nor -p
" Commented out because it fails for reasons unknown after upgrade from
" vim 7.2 to 7.3
call system("bash -c \"mkdir -p ~/.vim-tmp\"")

" Make backups in a single central place.
" Ending in double backslash makes name of temp files include path, thus
" allowing backups to be made of two files edited with same filename.
set backupdir=~/.vim-tmp//
set directory=~/.vim-tmp//
set backupskip=/tmp/*,/private/tmp/*"
set backup
" persist undo info, so you can undo even after closing and re-opening a file
if version >= 730
    set undofile
    set undodir=~/.vim/tmp//
endif

" use 'comma' prefix for user-defined multi-stroke keyboard mappings
let mapleader = ","

if has("autocmd")

    " enables filetype detection
    filetype on
    " enables filetype specific plugins
    filetype plugin on
    " do language-dependent indenting.
    filetype indent off

    " For all text files set 'textwidth' to 80 characters.
    autocmd FileType text setlocal textwidth=80

    " make syntax highlighting work correctly on long files
    autocmd BufEnter * :syntax sync fromstart

    " When editing a file, always jump to the last known cursor position.
    autocmd BufReadPost * call SetLastCursorPosition()
    function! SetLastCursorPosition()
      " Don't do it when the position is invalid or when inside an event
      " handler (happens when dropping a file on gvim).
      if line("'\"") > 0 && line("'\"") <= line("$")
        exe "normal g`\""
        normal! zz
      endif
    endfunction

    " highlighting for unusual file extensions
    au BufNewFile,BufRead *.hql set filetype=sql
    au BufNewFile,BufRead *.sqli set filetype=sql

endif " has("autocmd")

" sane text files
set fileformat=unix
set fileformats=unix,dos,mac
set encoding=utf-8

" sane editing
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" indenting.
" *All* the smart indent settings and plugins are TOTALLY FUCKED.
" Disable them all
set nocindent
set indentexpr=
" except for plain autoindent, which preserves indent from the previous line)
set autoindent
" and smartindent, which indents in and out after { and }
set smartindent

" stop autoindent from unindenting lines typed starting with '#'
inoremap # X<backspace>#

" display and colors
set background=dark

" lastline: don't display truncated last lines as '@' chars
" uhex: show unprintable chars as hex <xx> instead of ^C and ~C.
set display+=lastline

" display current mode on the last line (e.g. '-- INSERT --')
set showmode

" display number of selected chars, lines, or size of blocks.
set showcmd

" always show status line
source ~/.vim/scripts/statusline.vim
set laststatus=2

set formatoptions-=t
set formatoptions-=c
set formatoptions+=r
set formatoptions+=o
set formatoptions+=q
set formatoptions-=w
set formatoptions-=a
" formatoptions 'n' stops autoformat from messing up numbered lists.
set formatoptions+=n
" Make autoformat of numbered lists also handle bullets, using asterisks:
set formatlistpat=^\\s*[0-9*]\\+[\\]:.)}\\t\ ]\\s*

" display long lines as wrapped
set wrap
" wrap at exactly char 80, not at word breaks
set nolinebreak
" show an ellipsis at the start of wrapped lines
set showbreak=\

" discretely highlight lines which are longer than the specified width
" only long lines are highlighted (making this less intrusive than colorcolumn)
" width defaults to 80. pass 0 to turn off.
function! s:HighlightLongLines(width)
    let targetWidth = a:width != '' ? a:width : 80
    if targetWidth > 0
        exec 'match ColorColumn /\%' . (targetWidth + 1) . 'v/'
    else
        exec 'match'
    endif
endfunction

command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')

" toggle the highlighting of long lines

let s:highlight_long_lines = 1

function! ToggleHighlightLongLines()
    if s:highlight_long_lines == 0
        HighlightLongLines
        let s:highlight_long_lines = 1
    else
        HighlightLongLines 0
        let s:highlight_long_lines = 0
    endif
endfunction
HighlightLongLines

noremap <leader>l :call ToggleHighlightLongLines()<cr>


" toggle wrapped appearance of long lines
function! ToggleWrap()
    if &wrap == 0
        set wrap
    else
        set nowrap
    endif
endfunction

noremap <leader>w :call ToggleWrap()<cr>


" key to toggle visibility of tabs & trailing whitespace
set listchars=tab:>-,trail:.
set nolist
nmap <silent> <leader>s :set nolist!<cr>

" key to strip trailing whitespace
nmap <silent> <leader>S ms:%s/\s\+$//<cr>`s

" key to toggle line numbers
" set nonumber
nmap <leader>n :set number!<cr>

" toggle between last two buffers
noremap <Leader><Leader> <c-^>

" allow cursor keys to go right off end of one line, onto start of next
set whichwrap+=<,>,[,]

" when joining lines, don't insert two spaces after punctuation
set nojoinspaces

" enable automatic yanking to and pasting from the selection
set clipboard+=unnamed

" make Y yank to end of line (consistent with C and D)
noremap Y y$

" make Q do somethign useful - format para
noremap Q gq}

" search for visual selection if one exists, otherwise for word under cursor
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

" I don't like folded regions
set nofoldenable

" omit intrusive 'press ENTER' (etc) status line messages
set shortmess=atTWI

set history=999


" 'grep' command should use 'grp' bash function, a wrapper for system grep
" which adds some common flags, like --exclude-dir=\.git.
" We add '-n' into that mix, so that output is parsable by vim quickfix window.
set grepprg=grp\ -n\ $*\ /dev/null

" make commands invoked by grep go via an interactive shell
" Without this, the bash alias 'grp' in 'grpprg' is not expanded
set shellcmdflag=-ci

" silent grep and then show results in quickfix
function! Grep(args)
    execute "silent grep " . a:args
    botright copen
endfunction

command! -nargs=* -complete=file Grep call Grep(<q-args>)

" Grep all files for the word under the cursor (& case insensitive version)
noremap <Leader>g :Grep -w '<c-r><c-w>' .<cr>
noremap <Leader>G :Grep -wi '<c-r><c-w>' .<cr>

" allow use of mouse pretty much everywhere
set mouse=a
set ttymouse=xterm2

" prevent security exploits. I never used modelines anyway.
set modelines=0

" places to look for tags files:
set tags=./tags,tags
" recursively search file's parent dirs for tags file
" set tags+=./tags;/
" recursively search cwd's parent dirs for tags file
set tags+=tags;/

" indicate a fast terminal - more redraw chars sent for smoother redraw
set ttyfast
" don't redraw while running macros
set nolazyredraw

" turn on syntax highlighting
syntax on

" files to hide in directory listings
let g:netrw_list_hide='\.py[oc]$,\.svn/$,\.git/$,\.hg/$'


" KEYBINDS

" move up/down by visible lines on long wrapped lines of text
nnoremap k gk
nnoremap j gj
vnoremap <a-4> g$
nnoremap <a-4> g$
vnoremap <a-0> g^
nnoremap <a-0> g^
nnoremap <a-6> g^
vnoremap <a-6> g^

" start typing commands without needing shift
nnoremap ; :

" go to prev buffer
" noremap <silent> <c-tab> :hide bp<cr>
" map! <silent> <c-tab> <esc><c-tab>
" go to next buffer
" noremap <silent> <s-c-tab> :hide bn<cr>
" map! <silent> <s-c-tab> <esc><s-c-tab>

" Windows-like keys for cut/copy/paste
vnoremap <c-x> "+x
vnoremap <c-c> "+y
"noremap <c-v> "+gP
"imap <c-v> <esc>"+gpi
"vmap <c-v> "-cx<Esc>\\paste\\"_x
"cnoremap <c-v> <c-r>+

" Open NERD Tree file
noremap <silent> <F2> :NERDTreeToggle<cr>
inoremap <silent> <F2> <ESC>:NERDTreeToggle<cr>

" save file
noremap <silent> <c-s> :wa<cr>
inoremap <silent> <c-s> <ESC>:wa<cr>

" quit file
noremap <silent> <c-q> :qa<cr>
inoremap <silent> <c-q> <c-o>:qa<cr>

" navigating quickfix
noremap <silent> <f3> :cnext<cr>
noremap <silent> <s-f3> :cprevious<cr>

" cd to current file
noremap <m-j> :cd %:p:h<cr>:pwd<cr>
map <m-down> <a-j>
map! <m-j> <esc><a-j>
map! <m-down> <a-j>
" cd ..
noremap <m-k> :cd ..<cr>:pwd<cr>
map <m-up> <a-k>
map! <m-k> <esc><a-k>
map! <m-up> <a-k>

" close buffer
noremap <c-backspace> :Bclose<cr>
noremap <c-s-backspace> :Bclose!<cr>

" close window
noremap <a-backspace> <c-w>c
map! <a-backspace> <esc><c-backspace>
" close all other windows
noremap <a-o> <c-w>o

" navigating between windows
noremap <c-left> <c-w>h
noremap <c-right> <c-w>l
noremap <c-up> <c-w>k
noremap <c-down> <c-w>j
map! <c-left> <esc><c-left>
map! <c-right> <esc><c-right>
map! <c-up> <esc><c-up>
map! <c-down> <esc><c-down>

" make cursor keys work during visual block selection
vnoremap <left> h
vnoremap <right> l
vnoremap <up> k
vnoremap <down> j

" toggle autoformatting (my own personal group of settings for editing plain
" text files as opposed to code)
noremap <a-q> :python toggle_autoformat()<cr>

" disable annoying help on f1
noremap <silent> <f1> <esc>
map! <silent> <f1> <esc>

" set columns=80

" show vim in window title
set title

" generate tags for all (Python) files in or below current dir
" Mac & Linux
noremap <f12> :silent !pytags<cr>:FufRenewCache<cr>
" Windows
" noremap <m-f12> :!start /min ctags -R --languages=python .<cr>:FufRenewCache<cr>



" go to defn of tag under the cursor
" noremap <silent> <C-]> :set noic<cr>g<c-]>:set ic<cr>
fun! MatchCaseTag()
  let ic = &ic
  set noic
  try
    exe 'tjump ' . expand('<cword>')
  finally
    let &ic = ic
  endtry
endfun

nnoremap <silent> <c-]> :call MatchCaseTag()<CR>

" scroll faster
nnoremap <c-e> 4<c-e>
nnoremap <c-y> 4<c-y>

" scroll without moving cursor
noremap <c-pageup> 4<c-y>
noremap <c-pagedown> 4<c-e>


" fuzzyfind plugin

let s:extension = '\.bak|\.dll|\.exe|\.o|\.pyc|\.pyo|\.swp|\.swo'
let s:dirname = 'build|dist|vms|\.bzr|\.git|\.hg|\.svn|.+\.egg-info'

let s:slash = '[/\\]'
let s:startname = '(^|'.s:slash.')'
let s:endname = '($|'.s:slash.')'

let g:fuf_file_exclude = '\v'.'('.s:startname.'('.s:dirname.')'.s:endname.')|(('.s:extension.')$)'
let g:fuf_dir_exclude = '\v'.s:startname.'('.s:dirname.')'.s:endname
let g:fuf_enumeratingLimit = 60
let g:fuf_timeFormat = '    %Y%m%d %H:%M:%S'

nnoremap <Leader>f :FufFile **/<cr>
nnoremap <Leader>b :FufBuffer<cr>
nnoremap <Leader>t :FufTag<cr>
" unmap keys defined by bclose plugin that make my <leader>b slow
autocmd VimEnter * nunmap <Leader>bd


" glsl filetypes
command! SetGLSLFileType call SetGLSLFileType()
function! SetGLSLFileType()
  execute ':set filetype=glsl330'
  for item in getline(1,10)
    if item =~ "#version 400"
      execute ':set filetype=glsl400'
      break
    endif
  endfor
endfunction
au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl SetGLSLFileType

" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

set colorcolumn=79
set linebreak
set nu
set splitbelow                  " Split windows at bottom
set splitright

"autocmd BufWritePre *.py :%s/\s\+$//e
"autocmd BufWritePre *.sh :%s/\s\+$//e
"autocmd BufWritePre *.js :%s/\s\+$//e
"autocmd BufWritePre *.json :%s/\s\+$//e
"autocmd BufWritePre *.yml :%s/\s\+$//e
"autocmd BufWritePre *.html :%s/\s\+$//e
"autocmd BufWritePre *.xml :%s/\s\+$//e
"autocmd BufWritePre *.css :%s/\s\+$//e
"autocmd BufWritePre *.php :%s/\s\+$//e
"autocmd BufWritePre *.java :%s/\s\+$//e
"autocmd BufWritePre *.sql :%s/\s\+$//e
"autocmd BufWritePre *.c :%s/\s\+$//e
"autocmd BufWritePre *.cpp :%s/\s\+$//e

let g:flake8_max_complexity=5
let g:flake8_select='W,E,F'

set tags=tags,../tags,../../tags,../../../tags

" let g:NERDTreeWinSize=60
let NERDTreeIgnore = ['\.pyc$', '__pycache__']

map <ESC>[H <Home>
map <ESC>[F <End>
imap <ESC>[H <C-O><Home>
imap <ESC>[F <C-O><End>
cmap <ESC>[H <Home>
cmap <ESC>[F <End>

let g:ConqueTerm_ReadUnfocused = 1
set ff=unix
nmap ,l :TagbarOpenAutoClose<CR>
map <buffer> ,7 :call Flake8()<CR>

" Set the tabulars
nmap <Tab> ><Space>
nmap <S-Tab> <<Space>
xmap <Tab> >
xmap <S-Tab> <
imap <S-Tab> <C-o><<Space>

let g:NERDTreeMapPreview="<CR>"
let g:NERDTreeMapPreviewVSplit="<TAB>"
let g:NERDTreeMapPreviewSplit="<S-TAB>"

vmap <F6> :call PythonCommentSelection()<cr>
vmap <S-F6> :call PythonUncommentSelection()<cr>
map <F6> :call PythonCommentSelection()<cr>
map <S-F6> :call PythonUncommentSelection()<cr>
noremap <F7> :call Flake8()<cr>


highlight clear SpellBad
highlight SpellBad term=standout ctermfg=15 ctermbg=1 guifg=White guibg=Red
highlight clear MatchParen
highlight MatchParen term=standout ctermfg=Red
set nolist!


if !empty(glob("../../.vimrc_local"))
    so ../../.vimrc_local
endif
if !empty(glob("../.vimrc_local"))
    so ../.vimrc_local
endif
if !empty(glob(".vimrc_local"))
    so .vimrc_local
endif
