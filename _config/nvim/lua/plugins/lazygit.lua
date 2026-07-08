return {
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>",                  desc = "LazyGit" },
      { "<leader>gf", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit: current file commits" },
    },
  },
}
