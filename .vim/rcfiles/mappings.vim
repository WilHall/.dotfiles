" no arrows
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" fold, unfold
nnoremap <leader>ff za
nnoremap <leader>FF zA

" Maps for folding, unfolding all
nnoremap <LEADER>fa zM<CR>
nnoremap <LEADER>Fa zR<CR>

" shortcuts for substitutions
nnoremap <leader>sg :%s///g<left><left>
nnoremap <leader>sl :s///g<left><left>

" Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" shortcut to edit file in the same directory as the current file
nnoremap <Leader>e :e <C-R>=expand('%:p:h') . '/'<CR>

" buffer navigation
nnoremap <Leader>, :silent! bp<CR>
nnoremap <Leader>. :silent! bn<CR>
nnoremap <Leader>; :silent! bd<CR>

" resize splits
nnoremap <silent> <C-y> :exe "vertical resize -1"<cr>
nnoremap <silent> <C-o> :exe "vertical resize +1"<cr>
nnoremap <silent> <C-u> :exe "resize -1"<cr>
nnoremap <silent> <C-i> :exe "resize +1"<cr>

" delete surrounding function
nmap <silent> dsf ds)db

" write current buffer to the clipboard
nmap <silent> <Leader>cc :w !pbcopy<cr><cr>