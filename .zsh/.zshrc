ZSH_THEME=""
COMPLETION_WAITING_DOTS="false"
CASE_SENSITIVE="true"

# Cursor/VS Code environment probing may spawn an interactive zsh without a real TTY.
# In that case, skip heavy shell-initialization that can fail due to zle/prompt state.
if [[ $- == *i* ]] && ! ([[ -t 0 && -t 1 ]]); then
  return 0
fi

# Ghostty shell integration (prompt marking, cwd propagation, jump_to_prompt, etc.)
if [[ -n "${GHOSTTY_RESOURCES_DIR}" ]]; then
  source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
  # Ensure ghostty CLI is on PATH (.zshenv overwrites PATH and drops Ghostty's bin dir)
  [[ "$PLATFORM" == "macos" ]] && path=("${GHOSTTY_RESOURCES_DIR}/../MacOS" $path)
fi

unset -v GEM_HOME

# Cursor/VS Code can spawn shells in non-interactive/non-TTY modes while probing
# environment variables; pure prompt + zle can then fail and cause non-zero exit.
if [[ -t 0 && -t 1 && -z "${VSCODE_IPC_HOOK-}" ]]; then
  autoload -U promptinit; promptinit || true
  prompt pure 2>/dev/null || true
fi

# ─── zinit (plugin manager) ──────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "${ZINIT_HOME%/*}"
  git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

# Cache dir for compinit / completions
mkdir -p "${ZSH_CACHE_DIR:-$HOME/.zsh/cache}/completions"

# oh-my-zsh library + plugins (snippets — no oh-my-zsh framework needed)
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZP::asdf
zinit snippet OMZP::git
zinit snippet OMZP::heroku
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::dircycle

# Standalone plugins
zinit light mafredri/zsh-async
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zdharma-continuum/fast-syntax-highlighting

# Theme colors for fast-syntax-highlighting (must follow the plugin)
source ~/.zsh/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh

# Apply completions once after everything is loaded
autoload -Uz compinit && compinit
zinit cdreplay -q

# Pre-generate asdf completions so they exist before first use (plugin writes async)
if (( $+commands[asdf] )); then
  asdf completion zsh >| "${ZSH_CACHE_DIR:-$HOME/.zsh/cache}/completions/_asdf" 2>/dev/null
fi

for zsh_source in $HOME/.zsh/configs/*.zsh; do
  source $zsh_source
done

# fzf shell integration (Homebrew fzf)
source <(fzf --zsh)

# Atuin history (replace shell history UX)
# WSL/apt often ships Atuin <18, which registers _atuin_up_search_widget / _atuin_search_widget
# instead of atuin-up-search / atuin-search — binding the new names then yields "No such widget".
if (( $+commands[atuin] )); then
  eval "$(atuin init zsh)"
  # Up-arrow: both VT100 (^[[A) and application-cursor (^[OA); Windows terminals vary.
  if (( ${+widgets[atuin-up-search]} )); then
    bindkey '^[[A' atuin-up-search
    bindkey '^[OA' atuin-up-search
  elif (( ${+widgets[_atuin_up_search_widget]} )); then
    bindkey '^[[A' _atuin_up_search_widget
    bindkey '^[OA' _atuin_up_search_widget
  fi
  # fzf's `source <(fzf --zsh)` binds ^R to fzf-history-widget; ensure Atuin wins for history search
  if (( ${+widgets[atuin-search]} )); then
    bindkey -M emacs '^r' atuin-search
  elif (( ${+widgets[_atuin_search_widget]} )); then
    bindkey -M emacs '^r' _atuin_search_widget
  fi
  if (( ${+widgets[atuin-search-viins]} )); then
    bindkey -M viins '^r' atuin-search-viins
  elif (( ${+widgets[_atuin_search_widget]} )); then
    bindkey -M viins '^r' _atuin_search_widget
  fi
fi

bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

# Free C-s for tmux prefix (zsh incremental search forward); Atuin uses C-r and ↑ instead
bindkey -r '^s'  # was history-incremental-search-forward (also lets tmux receive C-s as prefix)

# ssh-agent: macOS has a launchd-managed agent + Keychain integration via
# `UseKeychain` in ~/.ssh/config — don't spawn a duplicate per shell. On other
# platforms, only spawn if no usable agent is already attached.
if [[ "$PLATFORM" != "macos" ]]; then
  if [[ -z "${SSH_AUTH_SOCK:-}" ]] || ! ssh-add -l >/dev/null 2>&1; then
    eval $(ssh-agent -s 2>/dev/null | grep -v '^echo ')
  fi
fi
(gpg-agent --daemon 2>/dev/null)

export _ZO_DOCTOR=0
# Initialize zoxide (must be at the end)
eval "$(zoxide init zsh)"

# Auto-start tmux when opening a new terminal (e.g. Ghostty)
# Use new-session -A so we never exec a failing attach-only client (that would exit
# the terminal with no shell left to run `|| exec tmux new-session`).
if [[ -o interactive ]] && [[ -z "$TMUX" ]] && (( $+commands[tmux] )); then
  exec tmux new-session -A -s main
fi
