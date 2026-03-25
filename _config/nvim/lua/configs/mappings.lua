vim.cmd [[
    " no arrows
    map <up> <nop>
    map <down> <nop>
    map <left> <nop>
    map <right> <nop>

    " fold, unfold
    nnoremap <leader>ff za
    nnoremap <leader>FF zA

    " Maps for folding, unfolding all
    nnoremap <leader>fa zM<cr>
    nnoremap <leader>Fa zR<cr>

    " Marks
    nnoremap m<leader> :delmarks a-zA-Z0-9<cr>

    " shortcuts for substitutions
    nnoremap <leader>sg :%s///g<left><left>
    nnoremap <leader>sl :s///g<left><left>

    " Make double-<Esc> clear search highlights
    nnoremap <silent> <esc><esc> <esc>:nohlsearch<cr><esc>

    " shortcut to edit file in the same directory as the current file
    nnoremap <leader>e :e <c-r>=expand('%:p:h') . '/'<cr>

    " navigate splits
    nmap <silent> <c-k> :wincmd k<CR>
    nmap <silent> <c-j> :wincmd j<CR>
    nmap <silent> <c-h> :wincmd h<CR>
    nmap <silent> <c-l> :wincmd l<CR>

    " resize splits
    nnoremap <silent> <c-y> :exe "vertical resize -1"<cr>
    nnoremap <silent> <c-o> :exe "vertical resize +1"<cr>
    nnoremap <silent> <c-u> :exe "resize -1"<cr>
    nnoremap <silent> <c-i> :exe "resize +1"<cr>

    " delete surrounding function
    nmap <silent> dsf ds)db

    " write current buffer to the clipboard
    nmap <silent> <leader>cc :w !pbcopy<cr><cr>

]]

-- Open diagnostics float (global lua mappings avoid vimscript map edge-cases).
local open_diagnostics_float = function()
  local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local line_diags = vim.diagnostic.get(0, { lnum = current_line })
  if #line_diags > 0 then
    vim.diagnostic.open_float(nil, {
      focusable = true,
      border = "rounded",
      source = "always",
      prefix = " ",
      scope = "cursor",
      close_events = { "CursorMoved", "BufHidden", "InsertCharPre", "WinLeave" },
    })
    return
  end

  -- No diagnostics at cursor: fallback to symbol/type hover.
  local ok = pcall(vim.lsp.buf.hover)
  if not ok then
    vim.diagnostic.open_float(nil, {
      focusable = true,
      border = "rounded",
      source = "always",
      prefix = " ",
      scope = "buffer",
      close_events = { "CursorMoved", "BufHidden", "InsertCharPre", "WinLeave" },
    })
  end
end

local close_open_floats = function()
  local closed_any = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local cfg = vim.api.nvim_win_get_config(win)
    if cfg and cfg.relative and cfg.relative ~= "" then
      pcall(vim.api.nvim_win_close, win, true)
      closed_any = true
    end
  end
  return closed_any
end

vim.keymap.set("n", "<Esc>", function()
  if close_open_floats() then
    return
  end
  vim.cmd("nohlsearch")
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>dd", open_diagnostics_float, { noremap = true, silent = true, nowait = true })
vim.keymap.set("n", "<leader>dh", open_diagnostics_float, { noremap = true, silent = true, nowait = true })