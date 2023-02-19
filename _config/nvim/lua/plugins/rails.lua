return {
  {
    "tpope/vim-rails",
    config = function()
      vim.cmd [[
        let g:loaded_ruby_provider = 0
        command! OV only|AV
      ]]
    end,
  },
}