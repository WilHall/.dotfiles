return {
  {
    "jesseleite/vim-agriculture",
    config = function()
      vim.cmd [[
        let g:agriculture#ag_options = '--case-sensitive'
      ]]
    end,
  },
}