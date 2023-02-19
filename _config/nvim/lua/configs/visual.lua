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

    " coc diagnostics
    hi CocErrorHighlight guifg=#c94940 gui=bold,undercurl cterm=bold,undercurl 
    hi CocWarningHighlight guifg=#f4b80f gui=bold,undercurl cterm=bold,undercurl 
    hi CocInfoHighlight guifg=#f4b80f gui=bold,undercurl cterm=bold,undercurl 
    hi CocHintHighlight guifg=#f4b80f gui=bold,undercurl cterm=bold,undercurl 
    hi CocUnusedHighlight guifg=#f4b80f gui=bold,undercurl cterm=bold,undercurl 
    hi CocDeprecatedHighlight guifg=#f4b80f gui=bold,undercurl cterm=bold,undercurl 
    hi CocErrorFloat guifg=#c94940 gui=bold 
    hi CocWarningFloat guifg=#f4b80f gui=bold 
    hi CocInfoFloat guifg=#f4b80f gui=bold 
    hi CocHintFloat guifg=#f4b80f gui=bold 

    hi! CocErrorSign guifg=#c94940 gui=bold
    hi! CocInfoSign guifg=#f4b80f gui=bold
    hi! CocHintSign guifg=#f4b80f gui=bold
    hi! CocWarningSign guifg=#f4b80f gui=bold

    hi! CocErrorVirtualText guifg=#c94940 gui=bold
    hi! CocInfoVirtualText guifg=#f4b80f gui=bold
    hi! CocHintVirtualText guifg=#f4b80f gui=bold
    hi! CocWarningVirtualText guifg=#f4b80f gui=bold

    hi! CocErrorFloat guifg=#c94940 gui=bold
    hi! CocHintFloat guifg=#f4b80f gui=bold

    " easy motion targets
    hi EasyMotionTarget guifg=#f4b80f guibg=black
]]