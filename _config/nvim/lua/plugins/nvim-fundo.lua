return {
  {
    "kevinhwang91/nvim-fundo",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Uses a dedicated undo persistence directory.
      vim.o.undofile = true
      vim.o.undodir = vim.fn.expand("$HOME/.local/share/nvim/undo")
    end,
  },
}

