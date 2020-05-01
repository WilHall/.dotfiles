Plug 'elzr/vim-json', { 'for': 'json' }

let g:vim_json_syntax_conceal = 0

" use `jq` to prettify json
function! s:PrettyJSON()
  %!jq .
  set filetype=json
endfunction
command! PrettyJSON :call <sid>PrettyJSON()

" match comments in json files
autocmd FileType json syntax match Comment +\/\/.\+$+
