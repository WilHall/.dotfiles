return {
  {
    "smoka7/multicursors.nvim",
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    cmd = {
      "MCstart",
      "MCvisual",
      "MCclear",
      "MCpattern",
      "MCvisualPattern",
      "MCunderCursor",
    },
    keys = {
      {
        "<leader>m",
        "<Cmd>MCstart<CR>",
        mode = { "n", "v" },
        desc = "Multicursors: start",
      },
    },
    config = function()
      require("multicursors").setup({})
    end,
  },
}

