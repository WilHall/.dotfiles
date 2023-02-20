return {
  {
    "svermeulen/vim-subversive",
    config = function()
      vim.cmd [[
        let g:subversivePreserveCursorPosition = 1

        nmap s <plug>(SubversiveSubstitute)
        nmap ss <plug>(SubversiveSubstituteLine)
        nmap S <plug>(SubversiveSubstituteToEndOfLine)
      ]]
    end,
  },
}