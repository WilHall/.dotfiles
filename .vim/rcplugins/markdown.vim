Plug 'tpope/vim-markdown', { 'for': ['markdown', 'markdown.mdx'] }
Plug 'jxnblk/vim-mdx-js', { 'for': ['markdown', 'markdown.mdx'] }

let g:markdown_fenced_languages = [
  \ 'sql',
  \ 'javascript',
  \ 'jsx=typescript.tsx',
  \ 'ruby',
  \ 'sh',
  \ 'yaml',
  \ 'typescript',
  \ 'tsx=typescript.tsx',
  \ 'html',
  \ 'vim',
  \ 'json',
  \ 'diff',
  \ 'css',
  \ 'scss',
  \ 'haskell',
  \ 'elm',
  \ 'python'
\ ]

function CopyMarkdownAsRichText() range
  echo system('echo '.shellescape(join(getline(a:firstline, a:lastline), "\n")).' | pandoc -f markdown | textutil -stdin -format html -convert rtf -stdout | pbcopy')
endfunction
com -range=% -nargs=0 CopyMarkdownAsRichText :<line1>,<line2>call CopyMarkdownAsRichText()
xnoremap <leader>r <esc>:'<,'>CopyMarkdownAsRichText<cr>
