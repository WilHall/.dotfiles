
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 100
vim.opt.signcolumn = "yes"

vim.cmd [[
    " General Vim Settings

    syntax on
    set noswapfile
    set shortmess+=FWAcs

    " configure leader
    nnoremap <SPACE> <NOP>
    let mapleader = " "
    set timeoutlen=375

    if has('mouse_sgr')
    set ttymouse=sgr
    endif

    set showcmd
    set clipboard^=unnamed,unnamedplus

    set hidden
    set laststatus=2
    set nofixendofline

    " autoreading
    set autoread
    autocmd FocusGained,BufEnter * :checktime 

    " autowriting
    set autowrite
    set autowriteall

    " undo
    set undofile
    set undodir=$HOME/.configs/undo
    set undolevels=10000
    set undoreload=20000

    " searching
    set ignorecase
    set smartcase
    set hlsearch
    set incsearch

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

    " whitespace
    set tabstop=4 softtabstop=0 expandtab shiftwidth=2 smarttab
    set backspace=2
    set nojoinspaces

    " wrapping / line length
    set linebreak
    set wrap
    autocmd VimResized * | set columns=120
    set textwidth=120
    set colorcolumn=+1

    " create interstitial directories when saving files
    augroup CreateDirsOnSave
        autocmd!
        autocmd BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
    augroup END
]]

-- Reinforce filetype detection for session-restored JS/TS buffers.
vim.filetype.add({
  extension = {
    ts = "typescript",
    tsx = "typescriptreact",
    js = "javascript",
    jsx = "javascriptreact",
  },
})

local ts_ft_group = vim.api.nvim_create_augroup("ForceTsJsFiletypesOnRestore", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = ts_ft_group,
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function(args)
    if vim.bo[args.buf].filetype ~= "" then
      return
    end

    local name = vim.api.nvim_buf_get_name(args.buf)
    if name:match("%.tsx$") then
      vim.bo[args.buf].filetype = "typescriptreact"
    elseif name:match("%.ts$") then
      vim.bo[args.buf].filetype = "typescript"
    elseif name:match("%.jsx$") then
      vim.bo[args.buf].filetype = "javascriptreact"
    elseif name:match("%.js$") then
      vim.bo[args.buf].filetype = "javascript"
    end
  end,
})
