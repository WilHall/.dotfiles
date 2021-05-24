Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

let g:_fzf_file_preview_options = '--ansi --preview "bat --theme="OneHalfDark" --style full --decorations always --color always {}"'
let g:_fzf_find_preview_options = '--delimiter : --nth 4..' . ' ' . g:_fzf_file_preview_options
let g:_fzf_preview_size = 'down:80%'

function! Fuzzy_Files()
    call fzf#vim#files('', fzf#vim#with_preview({ 'options': g:_fzf_file_preview_options}, g:_fzf_preview_size))
endfunction

function! Fuzzy_Find()
  call fzf#vim#ag('', fzf#vim#with_preview({'options': g:_fzf_find_preview_options }, g:_fzf_preview_size))
endfunction

nnoremap <c-f> :call Fuzzy_Files()<cr>
nnoremap <c-d> :call Fuzzy_Find()<cr>

let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.95 } }
" let g:fzf_layout = { 'tmux': '-p90%,60%' }

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'FzfBackground'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'FzfBackground'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
