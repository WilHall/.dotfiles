return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "frappe",
        transparent_background = true,
        dim_inactive = {
            enabled = true,
            shade = "dark",
            percentage = 0.15,
        },
        styles = {
            comments = {},
            conditionals = {},
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators =  {},
        },
        color_overrides = {},
        custom_highlights = function(colors)
            return {
                FloatBorder = { bg = "#FFFFFF" },
            }
        end,
        integrations = {
            cmp = true,
            coc_nvim = true,
            gitsigns = true,
            nvimtree = true,
            telescope = true,
            treesitter = true,
            treesitter_context = true,
            notify = true,
            vim_sneak = true,
            beacon = true,
            barbar = true,
        },
      })

      vim.cmd.colorscheme "catppuccin"
    end,
  },
}