# VSCode config — ported from RubyMine

A close port of my RubyMine 2026.1 setup (theme, fonts, editor behavior,
keybindings, plugins) to VSCode. Generated/curated from the exported RubyMine
config in [`../rubymine/`](../rubymine).

## Install

```sh
./install.sh
```

This regenerates the theme, symlinks `settings.json` + `keybindings.json` into
`~/Library/Application Support/Code/User/`, symlinks the custom theme extension
into `~/.vscode/extensions/`, and installs the extensions in `extensions.json`.
Existing real config files are backed up to `*.bak` once. Restart VSCode after.

> If the `code` CLI isn't installed yet, open VSCode and run
> **Shell Command: Install 'code' command in PATH**, then re-run `install.sh`.

## Layout

| File | Purpose |
|------|---------|
| `settings.json` | Editor/UI behavior, font, theme + icon selection |
| `keybindings.json` | Ported keymap overrides (see below) |
| `extensions.json` | Extension recommendations (= what `install.sh` installs) |
| `generate-theme.py` | Builds the theme from the RubyMine `.icls` (re-runnable) |
| `theme-extension/` | Minimal extension that contributes the custom theme |
| `install.sh` | Idempotent installer |

## Theme

`workbench.colorTheme` → **Catppuccin Frappe PrideCat**, an exact port of my
RubyMine `Catppuccin Frappe PrideCat.icls` editor scheme. Token colors and font
styles are pulled live from the `.icls`; the workbench (chrome) palette is built
on the Catppuccin Frappe palette the scheme is based on.

**To re-port after tweaking the scheme in RubyMine:** re-export RubyMine config
into `../rubymine/`, then run `/usr/bin/python3 generate-theme.py` (or just
`./install.sh`). Themes are contributed by an extension in VSCode, so the theme
lives in `theme-extension/` rather than as a loose file.

Icons use the official **Catppuccin Icons** extension (`catppuccin-frappe`).

## Keybindings ported

| Shortcut | Action | RubyMine origin |
|----------|--------|-----------------|
| `⌘⇧A` | Command Palette | ⌘⇧P is taken by a global shortcut; mirrors JetBrains "Find Action" |
| `⌥↵` | Quick Fix / context actions | JetBrains Alt+Enter (⌘. still works too) |
| `⌘R` | Recently used editors | RubyMine RecentFiles |
| `⇧⌘⌥S` | Sort lines ascending | EditorSortLines |
| `⌃⇧5` | Split terminal | Terminal.SplitVertically |
| `⌃.` / `⌃,` | Next / prev inline (AI) suggestion | Copilot cycle inlays |

Next/prev error needs no remap — `F8` / `⇧F8` are already the VSCode defaults.

## Notes & manual follow-ups

- **Method separators** (RubyMine `SHOW_METHOD_SEPARATORS`) have no native VSCode
  equivalent and weren't ported.
- **CodeGlancePro / line-num / lsp4ij / js-debugger** map to native VSCode
  features (minimap, line numbers, LSP, JS debugger) — no extension installed.
- **`ej`** (a RubyMine plugin) couldn't be confidently mapped — identify it and
  add an equivalent to `extensions.json` if you still want it.
- **`jasonnutter.vscode-codeowners`** is the equivalent for the JetBrains
  "Git Codeowners" plugin; swap if you prefer another.
- AI/full-line completion (RubyMine `ml-llm`) is covered by the Claude Code
  extension; add GitHub Copilot separately if you want inline completions.
