# laptop-backup

Twice-daily [restic](https://restic.net) backup of configured local folders to
Cloudflare R2, driven by a LaunchAgent. Designed to run identically on both
MacBooks from one shared config in `~/.dotfiles`.

## How it works

| Piece       | Path                                           | Role                                                                       |
|-------------|------------------------------------------------|----------------------------------------------------------------------------|
| LaunchAgent | `LaunchAgents/com.wilhall.laptop-backup.plist` | Schedules the wrapper at **02:00 & 14:00** (missed slots run on next wake) |
| Wrapper     | `LaunchAgents/laptop-backup/backup.sh`         | Parses config, runs `restic backup` + retention                            |
| Config      | `LaunchAgents/laptop-backup/config.yaml`       | Folders, excludes, retention, repo URL (non-secret)                        |
| Secrets     | `~/.auth` (gitignored)                         | R2 keys + restic password                                                  |

Restic dedups across machines and tags every snapshot with the **hostname**, so each machine has its own history and
retention. The wrapper **skips paths that don't exist** on the current machine, so the single `config.yaml` is safe
everywhere.

## Installation

```sh
brew install restic yq
# fill in ~/.auth and folders in config.yaml
bash ~/.dotfiles/LaunchAgents/install.sh
```

`RunAtLoad` is off, so installing won't trigger a run. It runs on a schedule, but can also be run manually:

```sh
# run now
launchctl kickstart -kp gui/$(id -u)/com.wilhall.laptop-backup
# watch
tail -f ~/Library/Logs/com.wilhall.laptop-backup.log
```

Or to run with synchronous console output:

```sh
/bin/bash ~/.dotfiles/LaunchAgents/laptop-backup/backup.sh
```

A failed run raises a macOS notification; success is silent.

## Restore

The `lbackup` zsh function (`.zsh/configs/fn_lbackup.zsh`) runs any restic
subcommand against this repo with the R2 creds + restic password auto-loaded
from `~/.auth`, so there's no env to export:

```sh
# all hosts
lbackup snapshots
# just this Mac
lbackup snapshots --host <hostname>
# restore from a backup
lbackup restore latest --host <hostname> --target /tmp/restore --include ~/some/path
```

## Browsing snapshots

All of these use the same `lbackup` wrapper (see [Restore](#restore)) — it's a
straight passthrough to `restic`, so every subcommand works with creds loaded.

Quick listing / search / peek:

```sh
# list a subtree of the latest snapshot
lbackup ls latest ~/Pictures
# find a file across all snapshots
lbackup find "*.pdf"
# print one file without restoring
lbackup dump latest ~/.dotfiles/Brewfile
```

**Browse the whole repo in Finder** with `lbackup mount` (mounts every snapshot
read-only under `snapshots/`):

```sh
mkdir -p ~/restic-mnt
lbackup mount ~/restic-mnt
open ~/restic-mnt/snapshots/latest
```

`restic mount` needs **macFUSE**, a kernel
extension for mounting virtual drives. First-time setup requires manual installation:

1. `brew install --cask macfuse`  (or `brew bundle`)
2. **System Settings → Privacy & Security** → "System software from developer
   *Benjamin Fleischer* was blocked" → **Allow**.
3. **Reboot** — the kext only loads after a restart.
4. **Apple Silicon only:** kexts need reduced security. Boot to **Recovery** → **Startup Security Utility** → select the
   disk → **Reduced
   Security** → tick **"Allow user management of kernel extensions from identified
   developers"** → reboot.
