vim.cmd [[
    " color settings
    set t_Co=256
    set termguicolors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

    " underline settings
    let &t_Cs = "\e[4:3m"
    let &t_Ce = "\e[4:0m"

    " cursor settings
    let &t_SI.="\e[5 q"
    let &t_SR.="\e[4 q"
    let &t_EI.="\e[1 q"

    " show cursorline in insert mode
    autocmd InsertEnter,InsertLeave * set cursorline!

    " spell check
    hi SpellBad cterm=undercurl gui=undercurl

    " easy motion targets
    hi EasyMotionTarget guifg=#f4b80f guibg=black
]]