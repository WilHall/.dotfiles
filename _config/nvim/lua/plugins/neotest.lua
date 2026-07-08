return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "folke/neodev.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "olimorris/neotest-rspec",
      "thenbe/neotest-playwright"
    },
    config = function()
      require("neodev").setup({
        library = { plugins = { "neotest" }, types = true }
      })

      require('neotest').setup({
        adapters = {
          -- neotest-vitest finds the nearest vitest.config per test file, so
          -- monorepos with per-workspace configs (like CTW) work out of the box.
          require('neotest-vitest'),
          require('neotest-jest')({
            jestCommand = "yarn test --",
            jestConfigFile = "jest.config.json",
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          }),
        }
      })

      local opts = { noremap = true, silent = true }

      vim.keymap.set('n', '<C-t>s', function()
        require("neotest").summary.toggle()
      end, opts)

      vim.keymap.set('n', '<C-t>o', function()
        require("neotest").output.open()
      end, opts)

      vim.keymap.set('n', '<C-t>w', function()
        require("neotest").watch.watch()
        require("neotest").output_panel.open()
      end, opts)

      vim.keymap.set('n', '<C-t>wa', function()
        require("neotest").watch.watch(vim.fn.expand("%"))
        require("neotest").output_panel.open()
      end, opts)

      vim.keymap.set('n', '<C-t>t', function()
        require("neotest").run.run()
      end, opts)

      vim.keymap.set('n', '<C-t>a', function()
        require("neotest").run.run(vim.fn.expand("%"))
      end, opts)
    end
  },
}
