## .dotfiles

macOS dotfiles, application settings, and user defaults


### Bootstrapping

1. `clone git@github.com:WilHall/.dotfiles.git ~/.dotfiles/`
1. `cd ~/.dotfiles`
1. `./bootstrap <DOTFILES_GITHUB_PERSONAL_ACCESS_TOKEN>`


### Backing Up and Restoring macOS User Defaults

I've created a command line utility `dx` for backing up and restoring macOS
user defaults to my dotfiles:

***Note: If you are committing backed up user defaults to a public repository,
make sure to audit them first. Some applications may store sensitive information
such as license keys, names, emails, or file system information.***

```shell
This utility performs backups and restorations of macOS user defaults.
Backups are managed in `~/.defaults/`.

OPTIONS:
   -h | --help        Show this message
   -r | --restore     <DOMAIN> The domain to restore
   -R | --restore-all Restore all domains that have backups
   -b | --backup      <DOMAIN> The domain to back up
   -B | --backup-all  Back up all domains that already have backups

<DOMAIN> is one of:
-globalDomain  The macOS global domain
<DOMAIN_NAME>  The fully-qualified domain name (e.g. application bundle identifier)
<APP_NAME>     The application name (e.g. `/Applications/<APP_NAME>.app`
```

#### Examples

1. Backing up defaults for Safari: `dx --backup Safari`
1. Restoring the Safari backup: `dx --restore Safari`
1. Perform a backup for all domains that already have backups: `dx
   --backup-all`
1. Restore all existing backups: `dx --restore-all`

#### Backing up macOS system user defaults

Some macOS system settings, or settings that are changed in `System
Preferences`, are not stored in a domain that corresponds to a particular application.

Some system settings are stored in the domain `-globalDomain`, and others are
stored in particular system domains.

If backing up defaults using the app name (e.g. `dx --backup <APP_NAME>`) does
not include the settings you are looking for, try the following:

1. In a terminal window, run `fswatch / -e ".*" -i "\\.plist$"` to watch for plist file changes
1. In the GUI, modify the application setting(s) you wish to back up
1. Look through the terminal output for plist files that were modified
1. Try backing up those plist domains to see what they contain by running `dx
   --backup <PLIST_FILE_NAME>` (without the `.plist` extension)

