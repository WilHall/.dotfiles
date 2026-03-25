return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signcolumn = true,
        numhl = false,
        linehl = false,
        watch_gitdir = {
          follow_files = true,
        },
        -- We prefer the popup preview (`:Gitsigns blame_line`) over virtual text.
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
          use_focus = true,
        },
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")
          local function map(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true })
          end

          -- Popover-style blame for the current line.
          map("n", "<leader>gb", function()
            gitsigns.blame_line({ full = true })
          end)
          -- Toggle virtual-text blame (optional fallback).
          map("n", "<leader>gB", gitsigns.toggle_current_line_blame)
        end,
      })
    end,
  },
}

