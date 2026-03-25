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

fpath+=$HOME/.pure
# Cursor/VS Code can spawn shells in non-interactive/non-TTY modes while probing
# environment variables; pure prompt + zle can then fail and cause non-zero exit.
if [[ -t 0 && -t 1 && -z "${VSCODE_IPC_HOOK-}" ]]; then
  autoload -U promptinit; promptinit || true
  prompt pure 2>/dev/null || true
fi

if [[ "$PLATFORM" == "macos" ]]; then
  source /opt/homebrew/share/antigen/antigen.zsh
elif [[ "$PLATFORM" == "wsl" ]]; then
  source /usr/share/zsh-antigen/antigen.zsh
fi

source ~/.zsh/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh

antigen use oh-my-zsh

# Ensure oh-my-zsh cache completions dir exists (for asdf and other plugins)
mkdir -p "${ZSH_CACHE_DIR:-$HOME/.zsh/cache}/completions"

antigen bundle asdf
antigen bundle git
antigen bundle heroku
antigen bundle colored-man-pages
antigen bundle dircycle
antigen bundle mafredri/zsh-async@main
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-autosuggestions
antigen bundle Aloxaf/fzf-tab
antigen bundle zdharma-continuum/fast-syntax-highlighting

antigen apply

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
eval "$(atuin init zsh)"
# Up-arrow: bind both common keycodes (^[[A = VT100, ^[OA = application cursor)
bindkey '^[[A' atuin-up-search
bindkey '^[OA' atuin-up-search
# fzf's `source <(fzf --zsh)` binds ^R to fzf-history-widget; ensure Atuin wins for history search
bindkey -M emacs '^r' atuin-search
bindkey -M viins '^r' atuin-search-viins

bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

# Free C-s for tmux prefix (zsh incremental search forward); Atuin uses C-r and ↑ instead
bindkey -r '^s'  # was history-incremental-search-forward (also lets tmux receive C-s as prefix)

eval $(ssh-agent -s 2>/dev/null | grep -v '^echo ')
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
