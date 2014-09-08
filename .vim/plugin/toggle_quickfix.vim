"-------------------------------------------------------------------------
" toggle quickfix window open / closed

function! s:QuickfixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    botright copen
    let g:qfix_win = bufnr("$")
  endif
endfunction

command! -bang -nargs=? QuickfixToggleCmd call <SID>QuickfixToggle(<bang>0)

nnoremap <silent> <f4> :QuickfixToggleCmd<cr>

