Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'styled-components/vim-styled-components'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

let g:jsx_ext_required = 1

autocmd BufEnter *.es6 setf javascript
