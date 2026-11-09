return {
  {
    -- `main` is a rewrite: this plugin only installs parsers/queries; highlighting
    -- and indentation are enabled per-buffer below. Requires `tree-sitter-cli`.
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter-context"
    },
    config = function()
      local treesitter = require("nvim-treesitter")

      treesitter.install({
        "scss",
        "markdown",
        "markdown_inline",
        "graphql",
        "regex",
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
      })

      local enable_treesitter = function(bufnr, language)
        if not pcall(vim.treesitter.start, bufnr, language) then
          return false
        end
        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        return true
      end

      -- Start treesitter for a buffer, installing its parser on first use
      -- (replaces the `auto_install` option from the old `master` branch).
      local attach = function(bufnr)
        local language = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
        if not language or enable_treesitter(bufnr, language) then
          return
        end
        if vim.tbl_contains(treesitter.get_available(), language) then
          treesitter.install(language):await(function()
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(bufnr) then
                enable_treesitter(bufnr, language)
              end
            end)
          end)
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterAttach", { clear = true }),
        callback = function(args)
          attach(args.buf)
        end,
      })

      -- Cover buffers that already had a filetype before this ran (e.g. restored sessions).
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype ~= "" then
          attach(bufnr)
        end
      end
    end
  },
}
