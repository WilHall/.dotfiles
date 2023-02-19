return {
  {
    "airblade/vim-gitgutter",
    config = function()
      vim.cmd [[
        let g:gitgutter_max_signs = 2000
        let g:gitgutter_map_keys = 0
        let g:gitgutter_override_sign_column_highlight = 0
      ]]
    end,
  },
}




