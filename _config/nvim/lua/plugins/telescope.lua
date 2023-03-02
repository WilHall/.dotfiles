return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",

    },
    config = function()
      vim.cmd [[
        autocmd User TelescopePreviewerLoaded setlocal wrap
        
        nnoremap <c-e> :Telescope resume<cr>
        nnoremap <c-h> :lua require'telescope.builtin'.search_history()<cr>
        
        nnoremap <c-f> :Telescope find_files results_title=false path_display=smart scroll_strategy=limit theme=dropdown layout_strategy=vertical layout_config={width=200,height=0.99,prompt_position="top",mirror=true,preview_cutoff=1,preview_height=0.65} mirror=true find_command=rg,--ignore,--hidden,--files,--smart-case<cr>
        nnoremap <c-d> :Telescope live_grep results_title=false path_display=smart scroll_strategy=limit theme=dropdown layout_strategy=vertical layout_config={width=200,height=0.99,prompt_position="top",mirror=true,preview_cutoff=1,preview_height=0.65} mirror=true vimgrep_arguments={"rg","--color=never","--no-heading","--with-filename","--line-number","--column","--smart-case","--vimgrep"}<cr>
        nnoremap <c-g>r :Telescope live_grep results_title=false path_display=smart scroll_strategy=limit theme=dropdown layout_strategy=vertical layout_config={width=200,height=0.99,prompt_position="top",mirror=true,preview_cutoff=1,preview_height=0.65} mirror=true vimgrep_arguments={"rg","--color=never","--no-heading","--with-filename","--line-number","--column","--smart-case","--glob=**/*.rb"}<cr>
        nnoremap <c-g>s :Telescope live_grep results_title=false path_display=smart scroll_strategy=limit theme=dropdown layout_strategy=vertical layout_config={width=200,height=0.99,prompt_position="top",mirror=true,preview_cutoff=1,preview_height=0.65} mirror=true vimgrep_arguments={"rg","--color=never","--no-heading","--with-filename","--line-number","--column","--smart-case","--glob=**/*.svelte"}<cr>
      ]]
    end,
  },
}