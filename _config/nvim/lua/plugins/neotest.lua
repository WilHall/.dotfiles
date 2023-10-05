return {
    {
      "nvim-neotest/neotest",
      dependencies = {
        "folke/neodev.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-jest",
        "olimorris/neotest-rspec",
        "thenbe/neotest-playwright"
      },
      config = function()
        require("neodev").setup({
          library = { plugins = { "neotest" }, types = true }
        })

        require('neotest').setup({
          adapters = {
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

        vim.keymap.set('n', '<C-t>s', function()
          require("neotest").summary.toggle()
        end, bufopts)

        vim.keymap.set('n', '<C-t>o', function()
          require("neotest").output.open()
        end, bufopts)

        vim.keymap.set('n', '<C-t>w', function()
          require("neotest").watch.watch()
          require("neotest").output_panel.open()
        end, bufopts)

        vim.keymap.set('n', '<C-t>wa', function()
          require("neotest").watch.watch(vim.fn.expand("%"))
          require("neotest").output_panel.open()

        end, bufopts)

        vim.keymap.set('n', '<C-t>t', function()
          require("neotest").run.run()
        end, bufopts)

        vim.keymap.set('n', '<C-t>a', function()
          require("neotest").run.run(vim.fn.expand("%"))
        end, bufopts)
      end
    },
  }
  