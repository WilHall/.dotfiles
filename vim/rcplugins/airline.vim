Plug 'vim-airline/vim-airline'

let g:airline_theme='onehalfdark'
let g:airline_powerline_fonts = 1
let g:airline_highlighting_cache = 1
let g:airline_focuslost_inactive = 1

" tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" hunks
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 1

" coc
let g:airline#extensions#coc#enabled = 1
let airline#extensions#coc#error_symbol = '!!'
let airline#extensions#coc#warning_symbol = '!'

nnoremap <Leader>, :bp<CR>
nnoremap <Leader>. :bn<CR>
nnoremap <Leader>; :bd<CR>
