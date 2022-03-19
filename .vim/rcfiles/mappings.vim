" no arrows
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" fold, unfold
nnoremap <leader>ff za
nnoremap <leader>FF zA

" Maps for folding, unfolding all
nnoremap <leader>fa zM<cr>
nnoremap <leader>Fa zR<cr>

" Marks
nnoremap m<leader> :delmarks a-zA-Z0-9<cr>

" shortcuts for substitutions
nnoremap <leader>sg :%s///g<left><left>
nnoremap <leader>sl :s///g<left><left>

" Make double-<Esc> clear search highlights
nnoremap <silent> <esc><esc> <esc>:nohlsearch<cr><esc>

" shortcut to edit file in the same directory as the current file
nnoremap <leader>e :e <c-r>=expand('%:p:h') . '/'<cr>

" buffer navigation
nnoremap <leader>, :silent! bp<cr>
nnoremap <leader>. :silent! bn<cr>
nnoremap <leader>; :silent! bd<cr>

" navigate splits
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" resize splits
nnoremap <silent> <c-y> :exe "vertical resize -1"<cr>
nnoremap <silent> <c-o> :exe "vertical resize +1"<cr>
nnoremap <silent> <c-u> :exe "resize -1"<cr>
nnoremap <silent> <c-i> :exe "resize +1"<cr>

" delete surrounding function
nmap <silent> dsf ds)db

" write current buffer to the clipboard
nmap <silent> <leader>cc :w !pbcopy<cr><cr>
