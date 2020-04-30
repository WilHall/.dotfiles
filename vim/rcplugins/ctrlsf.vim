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

let g:ctrlsf_mapping = {
     \ "quit": { "key": "q", "suffix": "<C-w>_" },
     \ }

nmap <leader>t <Plug>CtrlSFPrompt
nmap <leader>tt <Plug>CtrlSFCCwordExec
