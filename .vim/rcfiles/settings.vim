" General Vim Settings

syntax on

set nocompatible
set showcmd
set clipboard=unnamed
set hidden
set updatetime=100
set nobackup
set nowritebackup
set laststatus=2
set incsearch
set nofixendofline

" autoreading
set autoread
autocmd FocusGained,BufEnter * :checktime 

" autowriting
set autowrite
set autowriteall

" undo
set undofile
set undodir=$HOME/.vim/undo
set undolevels=10000
set undoreload=20000

" searching
set ignorecase
set smartcase
set hlsearch

" completion
set completeopt=menu,menuone,preview

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
autocmd VimResized * | set columns=80
set textwidth=80
set colorcolumn=+1
