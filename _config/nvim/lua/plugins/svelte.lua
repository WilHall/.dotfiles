return {
  {
    "evanleck/vim-svelte",
    config = function()
      vim.cmd [[
        let g:svelte_preprocessor_tags = [
          \ { 'name': 'ts', 'tag': 'script', 'as': 'typescript' }
          \ ]
        let g:svelte_preprocessors = ['ts', 'scss']
      ]]
    end,
  },
}