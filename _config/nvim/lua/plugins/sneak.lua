return {
  {
    "justinmk/vim-sneak",
    dependencies = {
      "tpope/vim-repeat"
    },
    config = function()
      vim.cmd [[
        let g:sneak#label = 1
        map <C-n> <Plug>Sneak_s
        map <C-m> <Plug>Sneak_S
        map f <Plug>Sneak_f
        map F <Plug>Sneak_F
        map t <Plug>Sneak_t
        map T <Plug>Sneak_T
      ]]
    end
  },
}