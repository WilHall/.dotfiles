return {
  {
    "haya14busa/incsearch.vim",
    "romainl/vim-cool",
    config = function()
      vim.cmd [[
        map /  <Plug>(incsearch-forward)
        map ?  <Plug>(incsearch-backward)
        map g/ <Plug>(incsearch-stay)
      ]]
    end,
  },
}