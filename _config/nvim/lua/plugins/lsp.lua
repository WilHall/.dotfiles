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
      "onsails/lspkind.nvim",
      "b0o/schemastore.nvim",
    },
    config = function()
      local luasnip = require('luasnip')
      local cmp_buffer = require('cmp_buffer')
      local cmp = require('cmp')
      local lspkind = require("lspkind")
      local copilot = require("copilot")
      local copilot_cmp = require("copilot_cmp")
      local asdf = "/opt/homebrew/bin/asdf"

      -- Copilot's LSP needs a recent Node (>= 22.13) regardless of whatever
      -- version the current project's .tool-versions pins, so bypass the asdf
      -- shim and run the newest Node installed under asdf directly.
      local newest_asdf_node = (function()
        local nodes = vim.fn.glob("~/.asdf/installs/nodejs/*/bin/node", true, true)
        table.sort(nodes, function(a, b)
          local version_a = vim.version.parse(a:match("nodejs/([%d%.]+)/") or "0.0.0")
          local version_b = vim.version.parse(b:match("nodejs/([%d%.]+)/") or "0.0.0")
          return version_a < version_b
        end)
        return nodes[#nodes] or "node"
      end)()

      copilot.setup({
        copilot_node_command = newest_asdf_node,
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

      -- copilot-cmp is unmaintained and its is_available uses the deprecated
      -- client.is_stopped() field call (warns on every startup); source
      -- instances __index this module table, so overriding here covers them.
      require("copilot_cmp.source").is_available = function(self)
        return self.client ~= nil
          and not self.client:is_stopped()
          and self.client.name == "copilot"
          and next(vim.lsp.get_clients({
            bufnr = vim.api.nvim_get_current_buf(),
            id = self.client.id,
          })) ~= nil
      end

      lspkind.init({
        symbol_map = {
          Copilot = ""
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

      -- Round the border on every LSP floating window (hover, signature help, etc.)
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
        vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
      end, opts)
      vim.keymap.set('n', '[e', function()
        vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
      end, opts)
      vim.keymap.set('n', '[g', function() vim.diagnostic.jump({ count = -1 }) end, opts)
      vim.keymap.set('n', ']g', function() vim.diagnostic.jump({ count = 1 }) end, opts)
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

      -- Buffer-local mappings + per-client tweaks, bound whenever ANY client
      -- attaches (LspAttach fires for every client, unlike a per-server
      -- on_attach, so keys like `gi` can never fall through to their Vim
      -- built-ins in an LSP buffer).
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf

          -- Biome (via conform) owns formatting for frontend filetypes;
          -- keep tsserver/stylelint from competing over it.
          if client and (client.name == "vtsls" or client.name == "stylelint_lsp") then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end

          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<leader>f', function()
            require('conform').format({ async = true, lsp_format = 'fallback' })
          end, bufopts)
        end,
      })

      local lsp_flags = {
        debounce_text_changes = 150,
      }

      -- Every server gets nvim-cmp's capabilities (snippets, resolve, etc.)
      -- and the shared flags.
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        flags = lsp_flags,
      })

      local function setup(server, config)
        vim.lsp.config(server, config or {})
        vim.lsp.enable(server)
      end

      setup("jsonls", {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- CTW mandates tw`...` / twx(...) for class names; teach the Tailwind
      -- server to complete inside them (classFunctions covers calls and
      -- tagged templates on v0.14.4+).
      setup("tailwindcss", {
        settings = {
          tailwindCSS = {
            classFunctions = { "tw", "twx" },
          },
        },
      })

      -- vtsls wraps the VS Code TypeScript extension; autoUseWorkspaceTsdk
      -- makes it pick up each repo's own TypeScript from node_modules.
      setup("vtsls", {
        settings = {
          vtsls = {
            autoUseWorkspaceTsdk = true,
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
          },
        },
      })

      setup("html")

      -- The css server flags Tailwind at-rules (@tailwind/@apply/@screen) as
      -- unknown; teach it about them via the repo's custom-data file when one
      -- exists, and silence the lint either way.
      local tailwind_custom_data = vim.fs.find('.vscode/tailwind.json', {
        upward = true,
        path = vim.fn.getcwd(),
        type = 'file',
      })[1]
      setup("cssls", {
        settings = {
          css = {
            validate = true,
            customData = tailwind_custom_data and { tailwind_custom_data } or nil,
            lint = { unknownAtRules = "ignore" },
          },
          scss = {
            validate = true,
            customData = tailwind_custom_data and { tailwind_custom_data } or nil,
            lint = { unknownAtRules = "ignore" },
          },
          less = { validate = true },
        },
      })

      -- Diagnostics, code actions, and organize-imports from the repo-local
      -- Biome; only starts in projects with a biome.json (workspace_required).
      -- Biome prefers utf-8 position encoding when offered; advertise only
      -- utf-16 so it matches every other client and buffers never end up
      -- with mixed offset encodings.
      setup("biome", {
        capabilities = {
          general = {
            positionEncodings = { "utf-16" },
          },
        },
      })

      -- Needs a graphql.config.* at the project root; CTW documents live in
      -- plain .ts files too, so extend the default filetypes.
      setup("graphql", {
        filetypes = { "graphql", "typescript", "typescriptreact", "javascriptreact" },
      })

      -- Surfaces sgconfig.yml rules (e.g. CTW's require-tw-for-classname)
      -- inline; prefer the project's own ast-grep binary.
      setup("ast_grep", {
        cmd = function(dispatchers, config)
          local cmd = "ast-grep"
          local root_dir = (config or {}).root_dir
          if root_dir then
            local local_cmd = vim.fs.joinpath(root_dir, "node_modules/.bin/ast-grep")
            if vim.fn.executable(local_cmd) == 1 then
              cmd = local_cmd
            end
          end
          return vim.lsp.rpc.start({ cmd, "lsp" }, dispatchers, { cwd = root_dir })
        end,
      })

      setup("ruby_lsp", {
        filetypes = { "ruby" },
        cmd = { asdf, "exec", "ruby-lsp" },
        root_markers = { "Gemfile", ".git" },
        single_file_support = false,
      })
      setup("marksman")
      setup("stylelint_lsp")
      setup("svelte")
      setup("rust_analyzer")
      setup("pylsp")
      setup("lua_ls", {
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
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.INFO] = " ",
        [vim.diagnostic.severity.HINT] = " ",
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
