Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

function! Fuzzy_Files()
    let g:fzf_files_options = '--preview "bat --theme="OneHalfDark" --style=numbers,changes --color always {}"'
    call fzf#vim#files('', fzf#vim#with_preview('right:72%'))
endfunction

function! Fuzzy_Find()
  call fzf#vim#ag('', fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:72%'))
endfunction

nnoremap <C-f> :call Fuzzy_Files()<CR>
nnoremap <C-d> :call Fuzzy_Find()<CR>

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
