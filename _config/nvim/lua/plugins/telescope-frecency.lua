return {
  {
    "nvim-telescope/telescope-frecency.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("frecency")

      require("telescope").setup({
        extensions = {
          frecency = {
            -- Keep a rich enough timestamp history so the "90 days" recency bucket is reachable.
            max_timestamps = 50,
            ignore_register = function(bufnr)
              return not vim.bo[bufnr].buflisted
            end,
            show_scores = false,
            matcher = "default",
          },
        },
      })
    end,
  },
}

