Plug 'evanleck/vim-svelte', {'branch': 'main'}

let g:svelte_preprocessor_tags = [
  \ { 'name': 'ts', 'tag': 'script', 'as': 'typescript' }
  \ ]
let g:svelte_preprocessors = ['ts', 'scss']
