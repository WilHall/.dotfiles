# Symlink dotfiles into $HOME and config dirs into ~/.config.
#
# Whole-dir symlinks are fine when the dir holds only files we want tracked,
# OR when stray runtime state inside it is gitignored (e.g. ~/.gnupg).
# For dirs that mix tracked config with large machine-local state (Claude
# Code, gh CLI), use file-level symlinks via the helpers below and exclude
# the dir from the broad globs.

symlink_dotfiles() {
  # Top-level dotfiles, excluding the repo itself and the partial-tracking dirs.
  ln -sfn $HOME/.dotfiles/.^(gitignore|git|claude) $HOME/
  # _config/* into ~/.config, excluding partial-tracking subdirs.
  mkdir -p $HOME/.config && ln -sfn $HOME/.dotfiles/_config/^(gh|atuin) $HOME/.config
}

# File-level symlinks for ~/.claude — leaves Claude Code's per-project state
# (sessions, cache, history) untouched.
symlink_claude_config() {
  mkdir -p "$HOME/.claude"
  ln -sfn "$HOME/.dotfiles/.claude/CLAUDE.md"     "$HOME/.claude/CLAUDE.md"
  ln -sfn "$HOME/.dotfiles/.claude/settings.json" "$HOME/.claude/settings.json"
  ln -sfn "$HOME/.dotfiles/.claude/rules"         "$HOME/.claude/rules"
}

# File-level symlink for ~/.config/gh/config.yml only — hosts.yml carries the
# OAuth token and stays machine-local.
symlink_gh_config() {
  mkdir -p "$HOME/.config/gh"
  ln -sfn "$HOME/.dotfiles/_config/gh/config.yml" "$HOME/.config/gh/config.yml"
}

# File-level symlink for ~/.config/atuin/config.toml — atuin's `session` and
# `key` files stay machine-local.
symlink_atuin_config() {
  mkdir -p "$HOME/.config/atuin"
  ln -sfn "$HOME/.dotfiles/_config/atuin/config.toml" "$HOME/.config/atuin/config.toml"
}

# Merge tracked MCP servers into ~/.claude.json. ~/.claude.json can't be
# symlinked — it interleaves the mcpServers config we track with machine-local
# state (oauthAccount, caches, per-project history), so we reconcile just the
# one key and leave the file writable for Claude Code. Tracked servers win on
# key conflicts; servers added live but not yet captured in the repo are kept.
restore_claude_mcp_servers() {
  local repo="$HOME/.dotfiles/.claude/mcp-servers.json"
  local live="$HOME/.claude.json"
  [ -f "$repo" ] || return 0
  [ -f "$live" ] || return 0
  local tmp; tmp=$(mktemp)
  if jq --slurpfile mcp "$repo" \
      '.mcpServers = ((.mcpServers // {}) + $mcp[0])' "$live" > "$tmp"; then
    mv "$tmp" "$live"
  else
    rm -f "$tmp"
    echo "restore_claude_mcp_servers: failed to merge $repo into $live" >&2
  fi
}
