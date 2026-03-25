return {
  {
    "stevearc/conform.nvim",
    lazy = false,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")
      local util = require("conform.util")
      local lint = require("lint")
      local asdf = "/opt/homebrew/bin/asdf"

      conform.setup({
        format_on_save = function(bufnr)
          local ft = vim.bo[bufnr].filetype
          if ft == "ruby" then
            -- Ruby formatting via persistent ruby_lsp is much faster than
            -- spawning standardrb --fix per save.
            return {
              timeout_ms = 900,
              lsp_format = "prefer",
            }
          end
          return {
            timeout_ms = 1200,
            lsp_format = "last",
          }
        end,
        format_after_save = function(bufnr)
          local ft = vim.bo[bufnr].filetype
          if ft == "ruby" then
            return nil
          end
          return nil
        end,
        notify_on_error = true,
        formatters_by_ft = {
          javascript = { "biome_check_write_unsafe" },
          javascriptreact = { "biome_check_write_unsafe" },
          typescript = { "biome_check_write_unsafe" },
          typescriptreact = { "biome_check_write_unsafe" },
          json = { "biome_check_write_unsafe" },
          svelte = { "biome_check_write_unsafe" },

          ruby = {},
          eruby = { "erb_format" },
          erb = { "erb_format" },
          html = { "biome_check_write_unsafe" },
          ["html.erb"] = { "biome_check_write_unsafe" },
        },
        formatters = {
          biome_check_write_unsafe = {
            command = "biome",
            args = { "check", "--write", "--unsafe", "$FILENAME" },
            stdin = false,
            cwd = util.root_file({ "biome.jsonc", "biome.json", ".git" }),
            require_cwd = true,
          },
          standardrb_fix = {
            command = asdf,
            args = { "exec", "standardrb", "--fix", "--config", ".standard.yml", "$FILENAME" },
            stdin = false,
            cwd = util.root_file({ ".standard.yml", "Gemfile", ".git" }),
            require_cwd = true,
          },
        },
      })
      local run_ruby_fix = function(bufnr)
        if vim.bo[bufnr].filetype ~= "ruby" then
          return
        end
        if vim.b[bufnr].standardrb_running then
          return
        end
        vim.b[bufnr].standardrb_running = true

        conform.format({
          bufnr = bufnr,
          async = true,
          lsp_format = "never",
          formatters = { "standardrb_fix" },
        }, function(err)
          vim.b[bufnr].standardrb_running = false
          if err then
            return
          end
          lint.try_lint("standardrb")
        end)
      end

      vim.api.nvim_create_user_command("RubyFix", function()
        local bufnr = vim.api.nvim_get_current_buf()
        if vim.bo[bufnr].filetype ~= "ruby" then
          vim.notify("RubyFix only runs in ruby buffers", vim.log.levels.WARN)
          return
        end
        run_ruby_fix(bufnr)
      end, { desc = "Run standardrb --fix for current Ruby buffer" })

      vim.keymap.set("n", "<leader>rf", "<cmd>RubyFix<CR>", {
        noremap = true,
        silent = true,
        desc = "Run standardrb --fix",
      })
    end,
  },
}

