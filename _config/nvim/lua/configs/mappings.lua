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

    " split navigation (<c-h/j/k/l>) is owned by vim-tmux-navigator, which
    " moves seamlessly across nvim splits and tmux panes

    " resize splits
    nnoremap <silent> <c-y> :exe "vertical resize -1"<cr>
    nnoremap <silent> <c-o> :exe "vertical resize +1"<cr>
    nnoremap <silent> <c-u> :exe "resize -1"<cr>
    nnoremap <silent> <c-i> :exe "resize +1"<cr>

    " delete surrounding function
    nmap <silent> dsf ds)db

    " write current buffer to the clipboard
    nmap <silent> <leader>cc :w !pbcopy<cr><cr>

    " copy the current file's absolute path to the clipboard
    nnoremap <silent> <leader>cp :let @+ = expand('%:p')<cr>:echo 'Copied path: ' . expand('%:p')<cr>

]]

-- Open diagnostics float (global lua mappings avoid vimscript map edge-cases).
local open_diagnostics_float = function()
  local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
  -- Match the displayed-severity floor (INFO/HINT are omitted from the UI);
  -- info-only lines fall through to the hover fallback below.
  local line_diags = vim.diagnostic.get(0, {
    lnum = current_line,
    severity = { min = vim.diagnostic.severity.WARN },
  })
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

-- GitHub-style line fragment for the current position: `#L<n>` for the cursor
-- line, `#L<start>-L<end>` across a visual selection. Function-based maps keep
-- visual mode live, so line('v') and line('.') read the selection's two ends.
local line_fragment = function(visual)
  if not visual then
    return string.format("#L%d", vim.fn.line("."))
  end
  local start_line, end_line = vim.fn.line("v"), vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  return start_line == end_line and string.format("#L%d", start_line)
    or string.format("#L%d-L%d", start_line, end_line)
end

-- Copy the current file's absolute path plus a line reference to the clipboard.
local copy_path_with_line = function(visual)
  local reference = vim.fn.expand("%:p") .. line_fragment(visual)
  vim.fn.setreg("+", reference)
  vim.notify("Copied path: " .. reference)
end

vim.keymap.set("n", "<leader>cl", function()
  copy_path_with_line(false)
end, { noremap = true, silent = true, desc = "Copy file path with cursor line (GitHub-style)" })
vim.keymap.set("x", "<leader>cl", function()
  copy_path_with_line(true)
end, { noremap = true, silent = true, desc = "Copy file path with line range (GitHub-style)" })

-- Copy a browsable github.com (or GHE) blob URL for the current file + line
-- reference, anchored to the current commit so the link is a durable permalink.
local copy_github_link = function(visual)
  local file_dir = vim.fn.expand("%:p:h")
  local git = function(args)
    local output = vim.fn.systemlist(vim.list_extend({ "git", "-C", file_dir }, args))
    if vim.v.shell_error ~= 0 then
      return nil
    end
    return output[1]
  end

  local repo_root = git({ "rev-parse", "--show-toplevel" })
  if not repo_root then
    vim.notify("Not inside a git repository", vim.log.levels.WARN)
    return
  end

  -- Prefer the remote tracking the current branch; fall back to origin.
  local remote = "origin"
  local upstream = git({ "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}" })
  if upstream then
    remote = upstream:match("^([^/]+)/") or remote
  end

  local remote_url = git({ "remote", "get-url", remote })
  if not remote_url then
    vim.notify("No '" .. remote .. "' remote to build a link from", vim.log.levels.WARN)
    return
  end

  -- Normalise scp-style (git@host:owner/repo) and URL-style remotes to a web base.
  local trimmed = remote_url:gsub("%.git$", "")
  local host, project = trimmed:match("^[^/@]+@([^:/]+):(.+)$")
  local web_base
  if host then
    web_base = string.format("https://%s/%s", host, project)
  else
    local rest = trimmed:match("^%w+://(.+)$")
    web_base = rest and ("https://" .. rest:gsub("^[^@/]+@", ""))
  end
  if not web_base then
    vim.notify("Could not parse remote URL: " .. remote_url, vim.log.levels.WARN)
    return
  end

  -- Anchor to the current commit only if it has been pushed to the remote
  -- (i.e. a remote-tracking branch contains it); otherwise fall back to main.
  local commit = git({ "rev-parse", "HEAD" })
  local pushed = git({ "branch", "-r", "--contains", commit, "--list", remote .. "/*" }) ~= nil
  local ref = pushed and commit or "main"

  local relative_path = vim.fn.expand("%:p"):sub(#repo_root + 2)
  local link = string.format("%s/blob/%s/%s%s", web_base, ref, relative_path, line_fragment(visual))
  vim.fn.setreg("+", link)
  vim.notify("Copied GitHub link: " .. link)
end

vim.keymap.set("n", "<leader>cg", function()
  copy_github_link(false)
end, { noremap = true, silent = true, desc = "Copy GitHub permalink to cursor line" })
vim.keymap.set("x", "<leader>cg", function()
  copy_github_link(true)
end, { noremap = true, silent = true, desc = "Copy GitHub permalink to line range" })