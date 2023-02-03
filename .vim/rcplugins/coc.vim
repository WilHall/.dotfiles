Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
  \ 'coc-css',
  \ 'coc-json',
  \ 'coc-tsserver',
  \ 'coc-tailwindcss',
  \ 'coc-svelte',
  \ 'coc-html',
  \ 'coc-yaml',
  \ 'coc-vimlsp',
  \ 'coc-svg',
  \ 'coc-actions',
  \ 'coc-lists',
  \ 'coc-json',
  \ 'coc-yank',
  \ 'coc-pairs',
  \ 'coc-highlight',
  \ 'coc-solargraph',
  \ 'coc-styled-components',
  \ ]

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/stylelint')
  let g:coc_global_extensions += ['coc-stylelintplus']
endif

function! s:check_eslint()
  if !isdirectory('./node_modules') || !isdirectory('./node_modules/eslint')
    call coc#config('eslint', {
    \ 'enable': v:false,
    \ })
  endif
endfunction

autocmd BufEnter *.{js,jsx,ts,tsx} :call <SID>check_eslint()

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#_select_confirm() :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  let g:coc_snippet_next = '<tab>'

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <plug>(coc-diagnostic-prev)
nmap <silent> ]g <plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <plug>(coc-definition)
nmap <silent> gt <plug>(coc-type-definition)
nmap <silent> gi <plug>(coc-implementation)
nmap <silent> gr <plug>(coc-references)

" show documentation
function! s:show_documentation()
  if exists("g:coc_status") && g:coc_status !~ "Starting"
    if (CocHasProvider('hover'))
      call CocActionAsync('doHover')
    endif
  endif
endfunction
nnoremap <silent> H :call <sid>show_documentation()<cr>

" show diagnostics, otherwise documentation, on hold
function! ShowDocIfNoDiagnostic(timer_id)
  if exists("g:coc_status") && g:coc_status !~ "Starting"
    if (CocHasProvider('hover'))
      if (coc#float#has_float() == 0)
        silent call CocActionAsync('doHover')
      endif
    endif
  endif
endfunction

function! s:show_hover_doc()
  if exists("g:coc_status") && g:coc_status !~ "Starting"
    if (CocHasProvider('hover'))
      call timer_start(100, 'ShowDocIfNoDiagnostic')
    endif
  endif
endfunction

autocmd CursorHoldI * :call <sid>show_hover_doc()
autocmd CursorHold * :call <sid>show_hover_doc()

" common editor actions
nmap <leader>rn <plug>(coc-rename)

" Fix autofix problem of current line
nmap <leader>qf <plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.

xmap if <plug>(coc-funcobj-i)
xmap af <plug>(coc-funcobj-a)
omap if <plug>(coc-funcobj-i)
omap af <plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <c-d> <plug>(coc-range-select)
xmap <silent> <c-d> <plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" Show all diagnostics
nnoremap <silent> <space>d :<c-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e :<c-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c :<c-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o :<c-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s :<c-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j :<c-u>CocNext<cr>
" Do default action for previous item.
nnoremap <silent> <space>k :<c-u>CocPrev<cr>
" Resume latest coc list
nnoremap <silent> <space>p :<c-u>CocListResume<cr>

" actions menu
nmap <leader>m :CocCommand actions.open<cr>
nmap <c-a> :CocCommand actions.open<cr>
nmap <leader>do <plug>(coc-codeaction)

" command history
nmap <leader>h :CocList --top --number-select cmdhistory<cr>

" mru 
nmap <leader>r :CocList mru<cr>


" Use <c-space> to trigger completion.
if has('nvim')
  " map <silent> <c-space> <leader>cce"-yla<BS><c-r>-
   nmap <silent> <c-space> :CocCommand actions.open<cr>
else
  " map <silent> <c-@> <leader>cce"-yla<BS><c-r>-
   nmap <silent> <c-@> :CocCommand actions.open<cr>
endif

" Close all coc windows
nnoremap <leader>cc :cclose<cr>:pclose<cr>:call coc#util#float_hide()<cr>

" Restart coc
nnoremap <leader>cr :silent CocRestart<cr>
