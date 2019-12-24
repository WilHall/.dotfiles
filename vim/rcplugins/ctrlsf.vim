Plug 'dyng/ctrlsf.vim'

let g:ctrlsf_auto_close = {
    \ "normal" : 0,
    \ "compact": 0
    \}
let g:ctrlsf_context = '-B 5 -A 2'
let g:ctrlsf_auto_focus = {
    \ "at": "start"
    \ }
let g:ctrlsf_position = 'bottom'

nnoremap <leader>s :CtrlSF 
