# `dx` PII filters

`dx --backup` runs every exported plist through these filters before writing it
to `~/.defaults/<domain>.plist`. The intent is to strip identifiers, telemetry
IDs, account UUIDs, recent-search history, and other PII so the committed
snapshots are safe for a public repo.

## File layout

- **`_global`** — applied to every domain. Use for keys that appear under the
  same name across many apps (`BugsnagUserUserId`, etc.).
- **`<domain>`** — e.g. `com.apple.mail`. Applied only to that domain.

## Format

One entry per line. Blank lines and `#` comments are ignored. Two entry types:

```
# Literal — exact KVC key path from the plist root, dot-separated.
AccountOrdering
DefaultViewerState.SelectedMailboxOutlineItems

# Pattern — `~`-prefixed Python regex, fullmatch (anchored) against the
# key NAME at any depth in the plist tree.
~^NSWindow Frame .*$
~^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-.*$
```

Literals are surgical (only the exact path you specify is touched). Patterns
recursively walk the whole tree and remove **any** key whose name matches.

Keys that don't exist are silently skipped, so filters can be over-specified.

## Adding a new filter

1. Run `dx --backup <DOMAIN>` once and inspect `~/.defaults/<domain>.plist`
   for anything sensitive.
2. Add the offending key paths to either `<domain>` (specific) or `_global`
   (cross-cutting).
3. Re-run `dx --backup <DOMAIN>` — the filtered result is committed.

## What is not filtered

- **MAS receipts** (`MASMacAppStoreReceipt`) — needed for App Store apps to
  validate. Stripping breaks `defaults import` for those domains.

## What is filtered globally

- PII / per-installation IDs (`BugsnagUserUserId`, `SentryUserId`, etc.)
- **UUID-named keys at any depth** — Apple plists routinely use account /
  device / installation UUIDs as keys (e.g. Mail's per-account state). A
  generic pattern strips all of them so we don't need to enumerate.
- **Window/pane geometry** — Cocoa autosave keys (`NSWindow Frame *`,
  `NSSplitView Subview Frames *`, `NSToolbar Configuration *`) and the
  common third-party `MASPreferences ... Frame` pattern.

Per-app window geometry that doesn't use those conventions goes in the
domain-specific filter (e.g. Fantastical's `CalendarWindow*`).
