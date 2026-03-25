return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("typescript-tools").setup({
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
        },
      })

      -- Hotkeys / workflows for TS imports fixes on-demand.
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
        callback = function()
          pcall(vim.cmd, "silent! TSToolsOrganizeImports sync")
          pcall(vim.cmd, "silent! TSToolsAddMissingImports sync")
          pcall(vim.cmd, "silent! TSToolsRemoveUnusedImports sync")
        end,
      })
    end,
  },
}

