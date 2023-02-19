return {
  {
    "neoclide/coc.nvim",
    branch = "master",
    build = "yarn install --frozen-lockfile",
    config = function()
      vim.cmd [[
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
            \ 'coc-highlight',
            \ 'coc-solargraph',
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
        
        " command history
        nmap <leader>h :CocList --top --number-select cmdhistory<cr>
        
        " mru 
        nmap <leader>r :CocList mru<cr>

        " don't give |ins-completion-menu| messages.
        set shortmess+=c

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

        autocmd CursorHoldI * :call <sid>show_hover_doc()
        autocmd CursorHold * :call <sid>show_hover_doc()
      ]]

      local keyset = vim.keymap.set

      -- Use <c-j> to trigger snippets
      keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
      -- Use <c-space> to trigger completion
      keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

      -- Use `[g` and `]g` to navigate diagnostics
      -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
      keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
      keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

      -- GoTo code navigation
      keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
      keyset("n", "gt", "<Plug>(coc-type-definition)", {silent = true})
      keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
      keyset("n", "gr", "<Plug>(coc-references)", {silent = true})


      -- Use K to show documentation in preview window
      function _G.show_docs()
          local cw = vim.fn.expand('<cword>')
          if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
              vim.api.nvim_command('h ' .. cw)
          elseif vim.api.nvim_eval('coc#rpc#ready()') then
              vim.fn.CocActionAsync('doHover')
          else
              vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
          end
      end
      keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

      vim.api.nvim_create_augroup("CocGroup", {})

      -- Symbol renaming
      keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})


      -- Formatting selected code
      keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
      keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})


      -- Setup formatexpr specified filetype(s)
      vim.api.nvim_create_autocmd("FileType", {
          group = "CocGroup",
          pattern = "typescript,json",
          command = "setl formatexpr=CocAction('formatSelected')",
          desc = "Setup formatexpr specified filetype(s)."
      })

      -- Update signature help on jump placeholder
      vim.api.nvim_create_autocmd("User", {
          group = "CocGroup",
          pattern = "CocJumpPlaceholder",
          command = "call CocActionAsync('showSignatureHelp')",
          desc = "Update signature help on jump placeholder"
      })

      -- Apply codeAction to the selected region
      -- Example: `<leader>aap` for current paragraph
      local opts = {silent = true, nowait = true}
      keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
      keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

      -- Remap keys for apply code actions at the cursor position.
      keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
      -- Remap keys for apply code actions affect whole buffer.
      keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
      -- Remap keys for applying codeActions to the current buffer
      keyset("n", "<leader>ac", "<Plug>(coc-codeaction)", opts)
      keyset("n", "<leader>do", "<Plug>(coc-codeaction)", opts)
      -- Apply the most preferred quickfix action on the current line.
      keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

      -- Remap keys for apply refactor code actions.
      keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
      keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
      keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

      -- Run the Code Lens actions on the current line
      keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)


      -- Map function and class text objects
      -- NOTE: Requires 'textDocument.documentSymbol' support from the language server
      keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
      keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
      keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
      keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
      keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
      keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
      keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
      keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)

      -- Use CTRL-S for selections ranges
      -- Requires 'textDocument/selectionRange' support of language server
      keyset("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
      keyset("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})


      -- Add `:Format` command to format current buffer
      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

      -- " Add `:Fold` command to fold current buffer
      vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})

      -- Add `:OR` command for organize imports of the current buffer
      vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

      -- Add (Neo)Vim's native statusline support
      -- NOTE: Please see `:h coc-status` for integrations with external plugins that
      -- provide custom statusline: lightline.vim, vim-airline
      vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

      -- Mappings for CoCList
      -- code actions and coc stuff
      ---@diagnostic disable-next-line: redefined-local
      local opts = {silent = true, nowait = true}
      -- Show all diagnostics
      keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
      -- Manage extensions
      keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
      -- Show commands
      keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
      -- Find symbol of current document
      keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
      -- Search workspace symbols
      keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
      -- Do default action for next item
      keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
      -- Do default action for previous item
      keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
      -- Resume latest coc list
      keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)
    end
  },
}