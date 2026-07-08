return {
  {
    "LintaoAmons/bookmarks.nvim",
    tag = "v4.0.0",
    dependencies = {
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("bookmarks").setup({
        -- Use the telescope picker rather than pulling in snacks.nvim.
        picker = { provider = "telescope" },
      })

      -- Under <leader>b rather than the plugin's suggested m-prefix maps,
      -- which would shadow vim-signature's mark workflow.
      local opts = { noremap = true, silent = true }
      vim.keymap.set({ "n", "v" }, "<leader>bm", "<cmd>BookmarksMark<cr>",
        vim.tbl_extend("force", opts, { desc = "Mark/rename bookmark" }))
      vim.keymap.set({ "n", "v" }, "<leader>bo", "<cmd>BookmarksGoto<cr>",
        vim.tbl_extend("force", opts, { desc = "Go to bookmark" }))
      vim.keymap.set({ "n", "v" }, "<leader>bt", "<cmd>BookmarksTree<cr>",
        vim.tbl_extend("force", opts, { desc = "Bookmarks tree view" }))
      vim.keymap.set({ "n", "v" }, "<leader>bd", "<cmd>BookmarksDesc<cr>",
        vim.tbl_extend("force", opts, { desc = "Describe bookmark" }))
      vim.keymap.set({ "n", "v" }, "<leader>ba", "<cmd>BookmarksCommands<cr>",
        vim.tbl_extend("force", opts, { desc = "All bookmark commands" }))
    end,
  },
}
