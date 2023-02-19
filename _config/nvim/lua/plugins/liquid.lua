return {
  {
    "tpope/vim-liquid",
    config = function()
      vim.cmd [[
        au BufEnter *.js.liquid set ft=javascript
      ]]
    end,
  },
}