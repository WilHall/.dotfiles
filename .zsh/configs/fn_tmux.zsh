# tmux workspace orchestration.

function workspace() {
  if [[ -z "$1" ]]; then
    echo "Usage: workspace <project-name>"
    return 1
  fi

  if [[ -z "$TMUX" ]]; then
    echo "workspace: not inside a tmux session"
    return 1
  fi

  local project="$1"
  local dir="$HOME/workspace/$project"

  if [[ ! -d "$dir" ]]; then
    echo "workspace: directory not found: $dir"
    return 1
  fi

  tmux new-window -n "$project" -c "$dir"
  tmux select-pane -T "$project"
  tmux send-keys "mprocs" Enter

  tmux split-window -v -c "$dir"
  tmux select-pane -T "$project"
  tmux send-keys "clear" Enter

  tmux select-layout even-vertical
  tmux select-pane -U
}

_workspace_complete() {
  local -a projects
  projects=(${(f)"$(find "$HOME/workspace" -mindepth 1 -maxdepth 1 -type d -not -name '.*' -exec basename {} \;)"})
  _describe 'project' projects
}
compdef _workspace_complete workspace
