return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      local asdf = "/opt/homebrew/bin/asdf"
      local sev = vim.diagnostic.severity

      lint.linters_by_ft = {
        javascript = { "biomejs" },
        javascriptreact = { "biomejs" },
        typescript = { "biomejs" },
        typescriptreact = { "biomejs" },
        json = { "biomejs" },

        ruby = { "standardrb" },
        eruby = {},
        erb = {},
      }

      -- "Live linting" for IDE-like feedback (Biome + standardrb).
      -- LSP diagnostics remain handled by your existing LSP setup.
      local grp = vim.api.nvim_create_augroup("NvimLintOnSaveAndEdit", { clear = true })

      -- `standardrb` and Biome return exit code 1 when issues are found, which
      -- shouldn't be treated as a fatal error for our diagnostics pipeline.
      if lint.linters and lint.linters.standardrb then
        lint.linters.standardrb.ignore_exitcode = true
        lint.linters.standardrb.cmd = asdf
        lint.linters.standardrb.args = { "exec", "standardrb", "--force-exclusion", "--format", "json", "--config", ".standard.yml", "%:p" }
        lint.linters.standardrb.stdin = false
        lint.linters.standardrb.append_fname = false
        lint.linters.standardrb.parser = function(output)
          local ok, decoded = pcall(vim.json.decode, output)
          if not ok or type(decoded) ~= "table" then
            return {}
          end

          local diagnostics = {}
          for _, file in ipairs(decoded.files or {}) do
            for _, off in ipairs(file.offenses or {}) do
              local loc = off.location or {}
              local start_line = loc.start_line or 1
              local start_col = loc.start_column or 1
              local last_line = loc.last_line or start_line
              local last_col = loc.last_column or start_col
              table.insert(diagnostics, {
                lnum = start_line - 1,
                col = start_col - 1,
                end_lnum = last_line - 1,
                end_col = last_col,
                severity = (off.severity == "error" and sev.ERROR or sev.WARN),
                message = off.message or "standardrb offense",
                code = off.cop_name,
                user_data = {
                  lsp = {
                    code = off.cop_name,
                  },
                },
              })
            end
          end
          return diagnostics
        end
      end
      if lint.linters and lint.linters.biomejs then
        lint.linters.biomejs.ignore_exitcode = true
      end

      vim.api.nvim_create_autocmd({ "InsertLeave" }, {
        group = grp,
        callback = function()
          local ft = vim.bo.filetype
          if ft == "ruby" then
            -- Run Ruby lint only on save to keep edit/leave insert responsive.
            return
          end
          lint.try_lint()
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePost", {
        group = grp,
        pattern = "*.rb",
        callback = function()
          lint.try_lint("standardrb")
        end,
      })

    end,
  },
}

