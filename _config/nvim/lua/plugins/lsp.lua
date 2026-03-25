return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "delphinus/cmp-ctags",
      "zbirenbaum/copilot.lua",
      "zbirenbaum/copilot-cmp",
      "nvim-tree/nvim-web-devicons",
      "onsails/lspkind.nvim"
    },
    config = function()
      local luasnip = require('luasnip')
      local cmp_buffer = require('cmp_buffer')
      local cmp = require('cmp')
      local lspkind = require("lspkind")
      local copilot = require("copilot")
      local copilot_cmp = require("copilot_cmp")
      local asdf = "/opt/homebrew/bin/asdf"

      copilot.setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        server_opts_overrides = {
          trace = "verbose",
          settings = {
            advanced = {
              listCount = 10,
              inlineSuggestCount = 3,
            }
          },
        }
      })

      copilot_cmp.setup({
        formatters = {
          label = require("copilot_cmp.format").format_label_text,
          insert_text = require("copilot_cmp.format").remove_existing,
          preview = require("copilot_cmp.format").deindent,
        },
      })

      lspkind.init({
        symbol_map = {
          Copilot = ""
        }
      })

      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

      vim.cmd([[ set pumheight=6 ]])
      cmp.setup {
        experimental = {
          native_menu = false,
          ghost_text = true,
        },
        preselect = true,
        completion = { completeopt = 'menu,menuone,noinsert' },
        sorting = {
          comparators = {
            require("copilot_cmp.comparators").prioritize,
            function(...) return cmp_buffer:compare_locality(...) end,
            cmp.config.compare.score,
            cmp.config.compare.priority,
            cmp.config.compare.order,
            cmp.config.compare.offset,
            cmp.config.compare.recently_used,
          },
        },
        formatting = {
          format = function(entry, vim_item)
            if vim.tbl_contains({ 'path' }, entry.source.name) then
              local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind = icon
                vim_item.kind_hl_group = hl_group
                return vim_item
              end
            end
            return require('lspkind').cmp_format({ with_text = false })(entry, vim_item)
          end
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<Up>'] = cmp.config.disable,
          ['<Down>'] = cmp.config.disable,
          ['<C-j>'] = cmp.mapping.scroll_docs(-4),
          ['<C-k>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<Tab>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<C-Down>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-Up>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = {
          { name = 'copilot',  priority = 40 },
          { name = 'nvim_lsp', priority = 20 },
          { name = 'luasnip',  priority = 20 },
          { name = 'ctags',    priority = 20 },
          { name = 'buffer',   priority = 10 },
          { name = 'path',     priority = 10 },
        },
      }

      vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
      vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=NONE guibg=#1f2335]]

      local border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      }

      -- LSP settings (for overriding per client)
      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
      }

      -- To instead override globally
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      -- Mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<leader>cr', function()
        -- Clear diagnostics first so the UI doesn't show stale diagnostics while servers restart.
        vim.diagnostic.reset()
        vim.cmd('LspRestart')
      end, opts)
      vim.keymap.set('n', '<leader>h', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', ']e', function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
      end, opts)
      vim.keymap.set('n', '[e', function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end, opts)
      vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)

      end

      local lsp_flags = {
        debounce_text_changes = 150,
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local function setup(server, config)
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      setup("jsonls", {
        capabilities = capabilities,
        on_attach = on_attach,
        flags = lsp_flags,
        handlers = handlers,
      })

      setup("tailwindcss", {
        on_attach = on_attach,
        flags = lsp_flags,
        handlers = handlers,
      })
      setup("ruby_lsp", {
        on_attach = on_attach,
        flags = lsp_flags,
        handlers = handlers,
        filetypes = { "ruby" },
        cmd = { asdf, "exec", "ruby-lsp" },
        root_markers = { "Gemfile", ".git" },
        single_file_support = false,
      })
      setup("marksman", {
        on_attach = on_attach,
        flags = lsp_flags,
        handlers = handlers,
      })
      setup("stylelint_lsp", {
        on_attach = on_attach,
        flags = lsp_flags,
        handlers = handlers,
      })
      setup("ts_ls", {
        on_attach = on_attach,
        flags = lsp_flags,
        handlers = handlers,
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      })
      setup("svelte", {
        on_attach = on_attach,
        flags = lsp_flags,
        handlers = handlers,
      })
      setup("rust_analyzer", {
        on_attach = on_attach,
        flags = lsp_flags,
        handlers = handlers,
      })
      setup("pylsp", {
        on_attach = on_attach,
        flags = lsp_flags,
        handlers = handlers
      })
      setup("lua_ls", {
        flags = lsp_flags,
        on_attach = on_attach,
        handlers = handlers,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      local diag_sign_text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.INFO] = " ",
        [vim.diagnostic.severity.HINT] = " ",
      }

      vim.diagnostic.config({
        signs = { text = diag_sign_text },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        virtual_text = false,
        float = {
          source = "always",
        },
      })

      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = "None", fg = "None" })
      vim.api.nvim_set_hl(0, 'FloatBorder', { bg = "None" })

      vim.cmd [[
        highlight! DiagnosticLineNrError guibg=#51202A guifg=#FF0000 gui=bold
        highlight! DiagnosticLineNrWarn guibg=#51412A guifg=#FFA500 gui=bold
        highlight! DiagnosticLineNrInfo guibg=#1E535D guifg=#00FFFF gui=bold
        highlight! DiagnosticLineNrHint guibg=#1E205D guifg=#0000FF gui=bold
      ]]
    end,
  },
}
