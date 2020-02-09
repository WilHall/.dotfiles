Plug 'svermeulen/vim-yoink'

let g:yoinkSavePersistently = 1
let g:yoinkSwapClampAtEnds = 0
let g:yoinkIncludeDeleteOperations = 1

nmap <c-[> <plug>(YoinkPostPasteSwapBack)
nmap <c-]> <plug>(YoinkPostPasteSwapForward)
nmap <leader>[y <plug>(YoinkRotateBack)
nmap <leader>]y <plug>(YoinkRotateForward)

nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)
