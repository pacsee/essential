" Based on wombat by Lars H. Nielsen (dengmao@gmail.com)

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "blackdev"


" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLine guibg=#1d1d1d
  hi CursorColumn guibg=#2d2d2d
  hi MatchParen guifg=#f6f3e8 guibg=#857b6f gui=bold
  hi Pmenu 		guifg=#f6f3e8 guibg=#444444
  hi PmenuSel 	guifg=#000000 guibg=#cae682
endif

" General colors
hi Cursor 		guifg=NONE    guibg=Orange  gui=none
hi Normal 		guifg=#f6f3e8 guibg=#000000 gui=none
hi NonText 		guifg=#808080 guibg=#101820 gui=none
hi LineNr 		guifg=#999999 guibg=#203040 gui=none
hi StatusLine 	guifg=#ffffff guibg=#406080 gui=bold
hi StatusLineNC guifg=#999999 guibg=#283c50 gui=none
hi VertSplit 	guifg=#444444 guibg=#444444 gui=none
hi Folded 		guibg=#384048 guifg=#a0a8b0 gui=none
hi Title		guifg=#f6f3e8 guibg=NONE	gui=bold
hi Visual		guifg=NONE    guibg=#262D51 gui=none
hi SpecialKey	guifg=#808080 guibg=#343434 gui=none
hi Search       guifg=#000000 guibg=#aaaa00 gui=none

" Syntax highlighting
hi Comment 		guifg=#99968b gui=none ctermfg=1 ctermbg=114 cterm=none
    
hi Todo 		guifg=#8f8f8f gui=none
hi Constant 	guifg=#e5786d gui=none
hi String 		guifg=#95e454 gui=none
hi Identifier 	guifg=#cae682 gui=none
hi Function 	guifg=#cae682 gui=none
hi Type 		guifg=#cae682 gui=none
hi Statement 	guifg=#8ac6f2 gui=none
hi Keyword		guifg=#8ac6f2 gui=none
hi PreProc 		guifg=#e5786d gui=none
hi Number		guifg=#e5786d gui=none
hi Special		guifg=#e7f6da gui=none

" jhartley custom
highlight Cursor guibg=orange guifg=black
highlight Search guibg=#0066aa guifg=NONE

