return {
  {
    "junegunn/fzf.vim",
    dependencies = {
      "junegunn/fzf"
    },
    config = function()
      vim.cmd [[
        let g:_fzf_file_preview_options = '--ansi --preview "bat --theme="Catppuccin-mocha" --layout=reverse --style full --decorations always --color always {}"'
        let g:_fzf_find_preview_options = '--delimiter : --nth 4..' . ' ' . g:_fzf_file_preview_options
        let g:_fzf_preview_size = 'down:80%'
        let g:ag_options = '--skip-vcs-ignores -u --path-to-ignore ~/.ignore'

        function! Fuzzy_Files()
            call fzf#vim#files('', fzf#vim#with_preview({ 'options': g:_fzf_file_preview_options}, g:_fzf_preview_size))
        endfunction

        function! Fuzzy_Find()
          call fzf#vim#ag('', g:ag_options, fzf#vim#with_preview({'options': g:_fzf_find_preview_options }, g:_fzf_preview_size))
        endfunction

        "let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.95 } }
        let g:fzf_layout = { 'tmux': '-p90%,90%' }

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
      ]]
    end,
  },
}
