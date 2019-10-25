" Visual Settings

" color scheme
colorscheme onehalfdark

" color settings
set t_Co=256
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

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

" list char highlights
hi Whitespace ctermfg=DarkGray guifg=#4a4a59
hi NonText ctermfg=DarkGray guifg=#4a4a59
hi SpecialKey ctermfg=DarkGray guifg=#4a4a59
hi VisualListChars ctermfg=DarkGray guifg=#4a4a59
match VisualListChars /\s/

" floating windows
highlight VertSplit guibg=NONE
highlight NormalFloat guifg=#999999 guibg=#222222
hi Pmenu guibg=#222222 guifg=#999999

" coc diagnostics
highlight CocErrorHighlight guifg=#c94940 gui=bold,undercurl guisp=Green
highlight CocWarningHighlight guifg=#f4b80f gui=bold,undercurl guisp=Green
highlight CocErrorLine guifg=#c94940 gui=bold,undercurl guisp=Green
highlight CocWarningLine guifg=#f4b80f gui=bold,undercurl guisp=Green
highlight CocErrorFloat guifg=#c94940 gui=bold,undercurl guisp=Green
highlight CocWarningFloat guifg=#f4b80f gui=bold,undercurl guisp=Green

" easy motion targets
hi EasyMotionTarget guifg=#f4b80f guibg=black