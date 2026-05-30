## .dotfiles

macOS, Linux, and Windows dotfiles, application settings, and user defaults.

## Quick start

### Bootstrap a new machine

If bootstrapping for Windows, perform all steps in a Windows Subsystem for Linux (WSL) terminal (see [How to install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install)).

1. `git clone git@github.com:WilHall/.dotfiles.git ~/.dotfiles/`
2. `cd ~/.dotfiles`
3. `./bootstrap <DOTFILES_GITHUB_PERSONAL_ACCESS_TOKEN>` *(first run only — subsequent runs read `~/.auth`)*

The bootstrap is intended to be idempotent; re-run any time to pick up newly tracked dotfiles, new Brewfile entries, etc.

### Check installation health

```sh
./dotctor             # read-only audit
./dotctor --fix       # auto-fix missing symlinks, stray .orig files, etc.
```

`dotctor` surveys symlinks, Brewfile drift, asdf versions, `~/.auth` mode and contents, the default shell, working-tree cleanliness, and secret-like files in the tree. Exits 0 on success, 1 if any check is in an error state.

## Repository conventions

Top-level directories serve distinct roles; the bootstrap reconciles them with `$HOME`.

| Path in repo                                | Linking behavior on bootstrap                                              | Bootstrap step              |
| ------------------------------------------- | -------------------------------------------------------------------------- | --------------------------- |
| `./.<x>`                                    | Symlink into `$HOME/.<x>` (whole directory)                                | `symlink_dotfiles`          |
| `./_config/<x>`                             | Symlink into `$HOME/.config/<x>`                                           | `symlink_dotfiles`          |
| `./.claude/{CLAUDE.md, settings.json, rules}` | File-level symlinks (per-project Claude Code state stays machine-local)  | `symlink_claude_config`     |
| `./_config/gh/config.yml`                   | File-level symlink — `hosts.yml` (OAuth token) stays machine-local          | `symlink_gh_config`         |
| `./.claude/mcp-servers.json`                | Merged into `~/.claude.json`'s `mcpServers` (can't symlink — file mixes config with machine state) | `restore_claude_mcp_servers` |
| `./bin/`                                    | `rsync` copy into `$HOME/.bin/`                                            | `make_user_bin`             |
| `./_ssh/`                                   | `rsync` copy into `$HOME/.ssh/`                                            | `configure_ssh`             |
| `./.defaults/`                              | macOS user-defaults snapshots, managed via `dx`                            | `restore_user_defaults`     |
| `./.appdata/`                               | Windows AppData/Registry snapshots, managed via `wx`                       | manual `wx` run             |
| `./userprofile/`                            | Files copied into Windows `%USERPROFILE%`                                  | `copy_userprofile_files`    |
| `./LaunchAgents/`                           | macOS `launchd` jobs (plist + sources)                                     | `install_launch_agents`     |
| `./font/`                                   | Font files installed system-wide                                           | `install_fonts`             |
| `./Brewfile`                                | Homebrew taps, formulae, casks, and Mac App Store apps (via `mas`)         | `install_homebrew_bundle`   |
| `./bootstrap.d/*.sh`                        | Bootstrap step modules (sourced by `./bootstrap`)                          | —                           |

Auxiliary inputs read by the bootstrap:

- `aptpkglist` — apt packages (WSL)
- `wingetpkgs` — winget packages (Windows)
- `.tool-versions` — asdf-managed runtime versions
- `.default-gems`, `.default-npm-packages` — packages installed for the asdf default
- `requirements.txt` — pip packages

## Tools

### `dx` — macOS user defaults backup and restore

Manages macOS user-defaults snapshots in `~/.defaults/`. Backups run through per-domain filters in `~/.defaults/.filters/` to strip PII (account UUIDs, telemetry IDs, window geometry, etc.) before they're committed.

```sh
dx --backup       <DOMAIN>   # Back up a single domain
dx --backup-all              # Back up all domains that already have snapshots
dx --restore      <DOMAIN>   # Restore a single domain
dx --restore-all             # Restore all domains
```

`<DOMAIN>` may be a bundle identifier (`com.apple.dock`), the `-globalDomain` literal, or an application name (e.g. `Safari`, which is resolved to `com.apple.Safari`).

***Note:*** If you commit backed-up defaults to a public repository, audit them first. Some applications store license keys, names, emails, or filesystem paths. Add new patterns to `~/.defaults/.filters/_global` or a per-domain filter as you encounter them — see `~/.defaults/.filters/README.md`.

#### Backing up macOS system settings

Some macOS settings (changed via System Settings) don't live in a per-app domain. They're typically in `-globalDomain` or a system-level domain.

If `dx --backup <APP_NAME>` doesn't include the setting you're after, find the domain manually:

1. In a terminal: `fswatch / -e ".*" -i "\\.plist$"` to watch for plist changes
2. Toggle the setting in System Settings
3. Look for the plist filename in the `fswatch` output
4. `dx --backup <plist_basename_without_extension>`

### `wx` — Windows AppData and Registry backup / restore

Manages Windows AppData files and Registry exports in `~/.appdata/`.

```sh
wx --backup       <SCOPE> <DOMAIN> [FILE_GLOB]
wx --backup-all   <SCOPE>
wx --restore      <SCOPE> <DOMAIN> [FILE_GLOB]
wx --restore-all  <SCOPE>
```

`<SCOPE>` is `Roaming`, `Local`, or `Registry`. For `Registry`, `<DOMAIN>` is the registry key path; for `Roaming`/`Local` it's a subpath under `%USERPROFILE%/AppData/<Scope>/`.

#### Finding Microsoft Store App IDs for `winget`

Copy the share URL from the Microsoft Store, grab the last path segment (the App ID), and substitute it into:

```
https://bspmts.mp.microsoft.com/v1/public/catalog/Retail/Products/<APPID>/applockerdata
```

Then copy the `packageIdentityName`.

### `dotctor` — installation health check

See [Check installation health](#check-installation-health) above.
