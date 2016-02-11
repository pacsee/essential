" used by ~/.vim/syntax/python.vim
let python_highlight_builtins = 1
let python_highlight_exceptions = 1
let python_highlight_string_formatting = 1
let python_highlight_string_format = 1
let python_highlight_string_templates = 1
let python_highlight_indent_errors = 1
let python_highlight_doctests = 1
let python_slow_sync = 1
let python_highlight_space_errors = 0
" highlight_all seems to irrevocably turn on space errors
"let python_highlight_all = 1

" auto indent after class, def, etc:
set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" autocompletion
set omnifunc=pythoncomplete#Complete
inoremap <c-space> <c-n>
inoremap <c-s-space> <c-p>

" disable all tests
map <f10> mz:%s/def test/def DONTtest/g<cr>'z
map <S-f10> mz:%s/def DONTtest/def test/g<cr>'z
" and a Mac version
map <D-f10> mz:%s/def test/def DONTtest/g<cr>'z
map <S-D-f10> mz:%s/def DONTtest/def test/g<cr>'z

" go to next/prev class
map <C-PageDown> /^class .*(.*):<cr>z<cr>
map <C-PageUp> ?^class .*(.*):<cr>z<cr>

" go to next/prev def
map <S-PageDown> /^\s*def .*(.*):<cr>z<cr>
map <S-PageUp> ?^\s*def .*(.*):<cr>z<cr>


" KEYBINDS for PLUGINS

" bicycle repair man
map ,e :BikeExtract<cr>
map ,r :BikeRename<cr>

" comment and uncomment selection
map  <M-c> :call PythonCommentSelection()<CR>
vmap <M-c> :call PythonCommentSelection()<CR>
map  <M-u> :call PythonUncommentSelection()<CR>j
vmap <M-u> :call PythonUncommentSelection()<CR>j
" same again for Mac, command-C and command-u
map  <D-c> :call PythonCommentSelection()<CR>
vmap <D-c> :call PythonCommentSelection()<CR>
map  <D-u> :call PythonUncommentSelection()<CR>j
vmap <D-u> :call PythonUncommentSelection()<CR>j

" Grep .py files for word under cursor (& case-insensitive version)
noremap <buffer> <Leader>g :Grep --include=*.py -w '<c-r><c-w>' .<cr>
noremap <buffer> <Leader>G :Grep --include=*.py -wi '<c-r><c-w>' .<cr>

