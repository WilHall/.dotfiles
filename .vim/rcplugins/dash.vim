Plug 'rizzatti/dash.vim'

nmap <silent> <leader>d <plug>DashSearch

let g:dash_map = {
    \ 'typescript.tsx' : ['typescript', 'react', 'javascript'],
    \ 'svelte' : ['svelte', 'tailwindcss']
    \ }
