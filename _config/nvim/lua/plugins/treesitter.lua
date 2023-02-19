return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter-context"
    },
    config = function()
      require'nvim-treesitter.configs'.setup({
        ensure_installed = { "scss", "markdown", "html", "bash", "diff", "css", "ruby", "lua", "javascript", "tsx", "typescript", "json", "svelte", "vim", "help" }
      })
    end
  },
}