# RubyMine config export

Exported portable config from **RubyMine 2026.1**
(`~/Library/Application Support/JetBrains/RubyMine2026.1`).

This is the same subset RubyMine's *File → Manage IDE Settings → Export Settings*
would produce, minus telemetry, caches, machine-specific paths, and secrets.

## Contents

| Path | What |
|------|------|
| `options/` | All IDE settings (editor, fonts, UI, VCS, language tools, …) |
| `colors/` | Custom editor color schemes (`.icls`), incl. `Catppuccin Frappe PrideCat` |
| `keymaps/` | Custom keymap (`VSCode (macOS) copy`) |
| `codestyles/` | Code style scheme |
| `inspection/` | Inspection profile |
| `plugins.txt` | Installed (non-bundled) plugins |

## Excluded on purpose

- **Secrets**: `rubymine.key` (license), `*.license`, `ssl/` — JetBrains stores
  account tokens in the macOS Keychain, not in these files.
- **Telemetry/stats**: `dailyLocalStatistics.xml`, `features.usage.statistics.xml`,
  `usage.statistics.xml`, `actionSummary.xml`, `contributorSummary.xml`,
  `inline.factors.completion.xml`, survey/feedback state.
- **Machine-specific**: `jdk.table.xml` (SDK paths), `recentProjects.xml`,
  `trusted-paths.xml`, `options/mac/`, `*.local.xml`.
- **Caches/binaries**: `*.db`, `plugins/` binaries (see `plugins.txt`),
  `workspace/`, `tasks/`, `settingsSync/`, `event-log-metadata/`.

## Restoring

Copy the folders back into a RubyMine config directory, or zip this folder and
use *Import Settings* in RubyMine. Re-install the plugins listed in
`plugins.txt` from the Marketplace.

## Related

The VSCode port of this setup lives in [`../vscode/`](../vscode); its theme is
generated from `colors/Catppuccin Frappe PrideCat.icls`.
