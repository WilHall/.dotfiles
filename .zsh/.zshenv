export PATH="$HOME/bin:$HOME/.local/bin:/opt/homebrew/bin:/usr/sbin:/usr/local/bin:$PATH"

export KEYTIMEOUT=1
export EDITOR='vim'
export REACT_EDITOR='none'

# I don't like dogs
export HUSKY_SKIP_HOOKS=1
export HUSKY_SKIP_INSTALL=1

export ERL_AFLAGS="-kernel shell_history enabled"

fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)
