return {
  {
    "windwp/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      require('spectre').setup({
        open_cmd = 'new',
        is_insert_mode = true
      })
      vim.cmd [[
        nnoremap <leader>S <cmd>lua require('spectre').open()<CR>

        "search current word
        nnoremap <leader>sw <cmd>lua require('spectre').open_visual({select_word=true})<CR>
        vnoremap <leader>s <esc>:lua require('spectre').open_visual()<CR>
        "  search in current file
        nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>
      ]]
    end
  },
}