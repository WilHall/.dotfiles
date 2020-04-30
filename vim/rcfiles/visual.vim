" Visual Settings

" color scheme
colorscheme onehalfdark

" color settings
set t_Co=256
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" underline settings
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

" cursor settings
let &t_SI.="\e[5 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[1 q"

" list settings
set list
set showbreak=↪\
set listchars=tab:→\ ,eol:¬,space:·,nbsp:␣,trail:·,extends:⟩,precedes:⟨

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" show cursorline in insert mode
autocmd InsertEnter,InsertLeave * set cursorline!

" list chars
hi Whitespace ctermfg=DarkGray guifg=#4a4a59
hi NonText ctermfg=DarkGray guifg=#4a4a59
hi SpecialKey ctermfg=DarkGray guifg=#4a4a59
hi VisualListChars ctermfg=DarkGray guifg=#4a4a59
match VisualListChars /\s/

" Folds
hi Folded ctermfg=DarkGray guifg=#6a6a69

" Highlights
hi CocHoverRange term=bold ctermbg=0 guibg=#474e5d
hi HighlightedyankRegion term=bold ctermbg=0 guibg=#474e5d

" Allow for terminal background transparency
hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi ColorColumn guibg=NONE ctermbg=NONE
hi CursorLine guibg=NONE ctermbg=NONE
hi GitGutterAdd guibg=NONE
hi GitGutterChange guibg=NONE
hi GitGutterDelete guibg=NONE
hi GitGutterChangeDelete guibg=NONE

" floating windows
hi VertSplit guibg=NONE
hi NormalFloat guifg=#999999 guibg=#222222
hi Pmenu guibg=#222222 guifg=#999999
hi FzfBackground guibg=#282c34

" spell check
hi SpellBad cterm=undercurl gui=undercurl

" coc diagnostics
hi CocErrorHighlight guifg=#c94940 gui=bold,undercurl cterm=bold,undercurl 
hi CocWarningHighlight guifg=#f4b80f gui=bold,undercurl cterm=bold,undercurl 
hi CocErrorFloat guifg=#c94940 gui=bold 
hi CocWarningFloat guifg=#f4b80f gui=bold 

" easy motion targets
hi EasyMotionTarget guifg=#f4b80f guibg=black
