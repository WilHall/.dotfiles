return {
  
  {
    "mattn/vim-gist",
    dependencies = {
      "mattn/webapi-vim"
    },
    config = function()
      vim.cmd [[
        let g:gist_clip_command = 'pbcopy'
        let g:gist_show_privates = 1
        let g:gist_post_private = 1
      ]]
    end,
  },
}




