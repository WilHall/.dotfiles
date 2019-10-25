" no arrows
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" fold, unfold
nnoremap <leader>ff za
nnoremap <leader>FF zA

" Maps for folding, unfolding all
nnoremap <LEADER>fu zM<CR>
nnoremap <LEADER>uf zR<CR>


" shortcuts for substitutions
nnoremap <leader>sg :%s///g<left><left>
nnoremap <leader>sl :s///g<left><left>

" Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" shortcut to edit file in the same directory as the current file
nnoremap <Leader>e :e <C-R>=expand('%:p:h') . '/'<CR>

" create splits
nnoremap <Leader>v :vsp<CR>
nnoremap <Leader>h :sp<CR>

" resize splits
nnoremap <silent> <C-y> :exe "vertical resize -1"<cr>
nnoremap <silent> <C-o> :exe "vertical resize +1"<cr>
nnoremap <silent> <C-u> :exe "resize -1"<cr>
nnoremap <silent> <C-i> :exe "resize +1"<cr>
