return {
  {
    "rmagatti/auto-session",
    event = "VimEnter",
    config = function()
      -- auto-session reopens previously open buffers from the last session
      -- for the current working directory.
      require("auto-session").setup({
        auto_restore = true,
        auto_save = true,
        auto_create = true,
        auto_restore_last_session = false,
        suppress_dirs = { "~/.config", "~/Downloads" },
      })
    end,
  },
}

