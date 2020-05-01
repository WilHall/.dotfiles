" configure leader
nnoremap <SPACE> <NOP>
let mapleader = " "
set timeoutlen=375

" add a binding for reloading vim configs
nnoremap <Leader>vr :source $MYVIMRC<CR>

" source core config files
function! s:SourceConfigFilesIn(directory)
  let directory_splat = '~/.vim/' . a:directory . '/*'
  for config_file in split(glob(directory_splat), '\n')
    if filereadable(config_file)
      execute 'source' config_file
    endif
  endfor
endfunction

" load plugins
call plug#begin('~/.vim/bundle')
call s:SourceConfigFilesIn('rcplugins')
call plug#end()

" source additional config files
call s:SourceConfigFilesIn('rcfiles')