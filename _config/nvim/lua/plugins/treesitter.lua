return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter-context"
    },
    config = function()
      require'nvim-treesitter.configs'.setup({
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
        ensure_installed = {
          "scss",
          "markdown",
          "html",
          "bash",
          "diff",
          "css",
          "ruby",
          "lua",
          "javascript",
          "tsx",
          "typescript",
          "embedded_template",
          "json",
          "svelte",
          "vim",
        }
      })

      -- Ensure TS/JS highlighting is started immediately, including restored buffers.
      local ts_group = vim.api.nvim_create_augroup("TreesitterTsImmediateHighlight", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = ts_group,
        pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
      vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
        group = ts_group,
        callback = function(args)
          local bufnr = vim.api.nvim_get_current_buf()
          if type(args) == "table" and type(args.buf) == "number" and vim.api.nvim_buf_is_valid(args.buf) then
            bufnr = args.buf
          end
          if not vim.api.nvim_buf_is_valid(bufnr) then
            return
          end
          local ft = vim.bo[bufnr].filetype
          if ft == "" then
            local name = vim.api.nvim_buf_get_name(bufnr)
            if name:match("%.tsx$") then
              ft = "typescriptreact"
            elseif name:match("%.ts$") then
              ft = "typescript"
            elseif name:match("%.jsx$") then
              ft = "javascriptreact"
            elseif name:match("%.js$") then
              ft = "javascript"
            end
          end
          if ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
            pcall(vim.treesitter.start, bufnr)
          end
        end,
      })
    end
  },
}
