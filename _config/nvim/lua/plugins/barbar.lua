return {
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local map = vim.api.nvim_set_keymap
      local opts = { noremap = true, silent = true }
      map('n', '<leader>,', '<Cmd>BufferPrevious<CR>', opts)
      map('n', '<leader>.', '<Cmd>BufferNext<CR>', opts)
      map('n', '<leader>;', '<Cmd>BufferClose<CR>', opts)
      require("bufferline").setup({
        animation = true,
        auto_hide = false,
        tabpages = true,
        closable = true,
        clickable = true,
        highlight_alternate = false,
        highlight_inactive_file_icons = false,
        highlight_visible = true,
        icons = {
          buffer_index = true,
          filetype = { enabled = true },
          diagnostics = {
            [vim.diagnostic.severity.ERROR] = {
              enabled = true,
              icon = ''
            },
            [vim.diagnostic.severity.WARN] = {
              enabled = false,
              icon = ''
            },
            [vim.diagnostic.severity.INFO] = {
              enabled = false,
              icon = ''
            },
            [vim.diagnostic.severity.HINT] = {
              enabled = true,
              icon = ''
            },
          },
          button = ' ✖',
          modified = {
            button = ' ✖',
          },
          pinned = {
            button = '  ',
          },
          separator = {
            left = '‖',
          },
          inactive = {
            separator = {
              left = '‖',
            }
          }
        },
        icon_custom_colors = false,
        insert_at_end = false,
        insert_at_start = false,
        maximum_padding = 1,
        minimum_padding = 1,
        maximum_length = 30,
        semantic_letters = true,
        letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
        no_name_title = nil,
      })
    end
  }
}