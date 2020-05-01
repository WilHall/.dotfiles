Plug 'junegunn/vim-easy-align'

command! ReformatTable normal vip<cr>**|
nmap <leader>rt :ReformatTable<cr>
vmap <cr> <Plug>(EasyAlign)
