Plug 'mhinz/vim-startify'

function! s:list_commits()
    let git = 'git'
    let commits = systemlist(git .' log --oneline | head -n10')
    let git = 'G'. git[1:]
    return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. git .' show ". matchstr(v:val, "^\\x\\+") }')
  endfunction

let g:startify_lists = [
  \ { 'header': ['   Sessions'],       'type': 'sessions' },
  \ { 'header': ['   MRU '. getcwd()], 'type': 'dir' },
  \ { 'header': ['   Commits'],        'type': function('s:list_commits') },
\ ]

let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
let g:startify_session_sort = 1
let g:startify_custom_header = 'startify#fortune#boxed()'
let g:startify_relative_path = 1

nnoremap <Leader>- :SClose<CR>
