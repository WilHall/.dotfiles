return {
  {
    "dyng/ctrlsf.vim",
    config = function()
      vim.cmd [[
        let g:ctrlsf_search_mode = 'async'
        let g:ctrlsf_default_view_mode = 'compact'
        let g:ctrlsf_auto_preview = 1
        let g:ctrlsf_auto_close = {
            \ "normal" : 0,
            \ "compact": 0
            \}
        let g:ctrlsf_context = '-B 5 -A 2'
        let g:ctrlsf_auto_focus = {
            \ "at": "start"
            \ }
        let g:ctrlsf_position = 'bottom'
        let g:ctrlsf_compact_position = 'bottom_inside'

        let g:ctrlsf_mapping = {
            \ "quit": { "key": "q", "suffix": "<C-w>_" },
            \ "next": "j",
            \ "prev": "k",
            \ }

        nmap <leader>t <plug>CtrlSFPrompt
        nmap <leader>tt <plug>CtrlSFCCwordExec
      ]]
    end,
  },
}

