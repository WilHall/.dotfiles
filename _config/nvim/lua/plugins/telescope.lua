return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-frecency.nvim",
    },
    config = function()
      local previewers = require("telescope.previewers")
      require("telescope").setup({
        extensions = {
          frecency = {
            -- Keep a rich enough timestamp history so the "90 days" recency bucket is reachable.
            max_timestamps = 50,
            ignore_register = function(bufnr)
              return not vim.bo[bufnr].buflisted
            end,
            show_scores = false,
            matcher = "default",
          },
        },
        defaults = {
          file_previewer = previewers.new_termopen_previewer({
            get_command = function(entry)
              local path = entry.value
              if not path or path == "" then
                return { "true" }
              end
              if vim.fn.isdirectory(path) == 1 then
                return { "ls", "-la", path }
              end
              return {
                "bat",
                "--theme=Catppuccin-mocha",
                "--style=plain",
                "--color=always",
                path,
              }
            end,
          }),
        },
      })

      require("telescope").load_extension("frecency")

      vim.cmd [[
        autocmd User TelescopePreviewerLoaded setlocal wrap

        nnoremap <c-e> :Telescope resume<cr>
        nnoremap <leader>sh :lua require'telescope.builtin'.search_history()<cr>
        
        nnoremap <c-f> :Telescope find_files results_title=false path_display=smart scroll_strategy=limit theme=dropdown layout_strategy=vertical layout_config={width=200,height=0.99,prompt_position="top",mirror=true,preview_cutoff=1,preview_height=0.65} mirror=true find_command=rg,--ignore,--hidden,--files,--smart-case<cr>
        nnoremap <c-d> :Telescope live_grep results_title=false path_display=smart scroll_strategy=limit theme=dropdown layout_strategy=vertical layout_config={width=200,height=0.99,prompt_position="top",mirror=true,preview_cutoff=1,preview_height=0.65} mirror=true vimgrep_arguments={"rg","--color=never","--no-heading","--with-filename","--line-number","--column","--smart-case","--vimgrep"}<cr>
        nnoremap <c-g>r :Telescope live_grep results_title=false path_display=smart scroll_strategy=limit theme=dropdown layout_strategy=vertical layout_config={width=200,height=0.99,prompt_position="top",mirror=true,preview_cutoff=1,preview_height=0.65} mirror=true vimgrep_arguments={"rg","--color=never","--no-heading","--with-filename","--line-number","--column","--smart-case","--glob=**/*.rb"}<cr>
        nnoremap <c-g>s :Telescope live_grep results_title=false path_display=smart scroll_strategy=limit theme=dropdown layout_strategy=vertical layout_config={width=200,height=0.99,prompt_position="top",mirror=true,preview_cutoff=1,preview_height=0.65} mirror=true vimgrep_arguments={"rg","--color=never","--no-heading","--with-filename","--line-number","--column","--smart-case","--glob=**/*.svelte"}<cr>
      ]]
    end,
  },
}