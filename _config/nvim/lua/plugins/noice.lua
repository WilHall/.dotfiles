return {
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify"
    },
    config = function()
      require("notify").setup({
        background_colour = "#000000"
      })
      require("noice").setup({
        cmdline = {
          view = "cmdline",
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = false,
          inc_rename = false,
          lsp_doc_border = true,
        },
      })
    end
  },
}
