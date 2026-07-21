return {
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          -- Rename the matching open/close tag live while editing one side.
          enable_rename = true,
          -- Leave tag auto-closing off; this plugin is here only for rename.
          enable_close = false,
          enable_close_on_slash = false,
        },
      })
    end,
  },
}
