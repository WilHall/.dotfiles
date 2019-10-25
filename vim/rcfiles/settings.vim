" General Vim Settings

syntax on

set nocompatible
set showcmd
set clipboard=unnamed
set hidden
set updatetime=100
set nobackup
set nowritebackup
set autowrite
set laststatus=2
set incsearch

" searching
set ignorecase
set smartcase
set hlsearch

" folding
set foldenable
set foldmethod=indent
set foldlevel=999

" splits
set splitbelow
set splitright

" gutters
set number
set numberwidth=5
set number norelativenumber
set signcolumn=yes

" whitespace
set tabstop=4 softtabstop=0 expandtab shiftwidth=2 smarttab
set backspace=2
set nojoinspaces

" wrapping / line length
set linebreak
set wrap
autocmd VimResized * | set columns=120
set colorcolumn=120
