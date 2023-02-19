return {
  {
    "junegunn/vim-easy-align",
    config = function()
      vim.cmd [[
        command! ReformatTable normal vip<cr>**|
        nmap <leader>rt :ReformatTable<cr>
        vmap <cr> <plug>(EasyAlign)
      ]]
    end,
  },
}

