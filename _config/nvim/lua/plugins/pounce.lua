return {
  {
    "rlane/pounce.nvim",
    config = function()
      vim.cmd [[
        nmap <C-/> <cmd>Pounce<CR>
        nmap <C-?> <cmd>PounceRepeat<CR>
        vmap <C-/> <cmd>Pounce<CR>
      ]]
    end
  },
}