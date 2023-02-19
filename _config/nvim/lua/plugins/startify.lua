return {
  {
    "mhinz/vim-startify",
    config = function()
      vim.cmd [[
        " returns all modified files of the current git repo
        " `2>/dev/null` makes the command fail quietly, so that when we are not
        " in a git repo, the list will be empty
        function! s:gitModified()
            let files = systemlist('git ls-files -m 2>/dev/null')
            return map(files, "{'line': v:val, 'path': v:val}")
        endfunction

        " same as above, but show untracked files, honouring .gitignore
        function! s:gitUntracked()
            let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
            return map(files, "{'line': v:val, 'path': v:val}")
        endfunction

        function! s:list_commits()
            let git = 'git'
            let commits = systemlist(git .' log --oneline | head -n10')
            let git = 'G'. git[1:]
            return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. git .' show ". matchstr(v:val, "^\\x\\+") }')
          endfunction

        let g:startify_lists = [
          \ { 'header': ['   Marks'], 'type': 'bookmarks' },
          \ { 'header': ['   MRU '. getcwd()], 'type': 'dir' },
          \ { 'type': function('s:gitUntracked'), 'header': ['   Untracked']},
          \ { 'type': function('s:gitModified'),  'header': ['   Modified']},
          \ { 'header': ['   Commits'], 'type': function('s:list_commits') },
        \ ]

        let g:startify_session_autoload = 1
        let g:startify_session_persistence = 1
        let g:startify_session_delete_buffers = 1
        let g:startify_change_to_dir = 0
        let g:startify_change_to_vcs_root = 0
        let g:startify_session_sort = 1
        let g:startify_custom_header = 'startify#fortune#boxed()'
        let g:startify_relative_path = 1

        nnoremap <leader>- :SClose<cr>
      ]]
    end,
  },
}