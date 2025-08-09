
#!/usr/bin/env bash

# Configuration for catpuccin theme
export FZF_DEFAULT_OPTS="\
--color=spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

PROJECT_DIRS_PATHS=(~/dev ~/data)
PROJECT_FILES_PATTERN="(settings\.xml|pom.xml|go.mod|package.json|[cC]argo.toml|.git\$)"
PROJECT_SEARCH_DEPTH="${PROJECT_SEARCH_DEPTH:-6}"

HOME_REPLACER=""                                          # default to a noop
echo "$HOME" | grep -E "^[a-zA-Z0-9\-_/.@]+$" &>/dev/null # chars safe to use in sed
HOME_SED_SAFE=$?
if [ $HOME_SED_SAFE -eq 0 ]; then # $HOME should be safe to use in sed
	HOME_REPLACER="s|^$HOME/|~/|"
fi

FZF_SESSIONS_HEADER=" ^x zoxide ^f projects"
FZF_SESSIONS_BORDER_LABEL="[ Tmux Sessions ]"
FZF_SESSION_COMMAND="tmux ls -F '#S'"
FZF_SESSIONS_BIND="ctrl-s:reload($FZF_SESSION_COMMAND)\
+change-border-label($FZF_SESSIONS_BORDER_LABEL)\
+change-header($FZF_SESSIONS_HEADER)\
+change-prompt( )"

FZF_ZOXIDE_HEADER=" ^s sessions ^f projects"
FZF_ZOXIDE_BORDER_LABEL="[ Recent Directories ]"
FZF_ZOXIDE_COMMNAD="zoxide query -l | sed -e \"$HOME_REPLACER\""
FZF_ZOXIDE_BIND="ctrl-x:reload($FZF_ZOXIDE_COMMNAD)\
+change-border-label($FZF_ZOXIDE_BORDER_LABEL)\
+change-header($FZF_ZOXIDE_HEADER)\
+change-prompt( )"

FZF_PROJECT_DIRS_HEADER=" ^s sessions ^x zoxide"
FZF_PROJECT_DIRS_BORDER_LABEL="[ Project Directories ]"
FZF_PROJECT_COMMAND="fd -H --maxdepth=$PROJECT_SEARCH_DEPTH --prune -x echo {//} \; \"$PROJECT_FILES_PATTERN\" ${PROJECT_DIRS_PATHS[*]} | sort | uniq | sed -e \"$HOME_REPLACER\""
FZF_PROJECT_DIRS_BIND="ctrl-f:reload($FZF_PROJECT_COMMAND)\
+change-border-label($FZF_PROJECT_DIRS_BORDER_LABEL)\
+change-header($FZF_PROJECT_DIRS_HEADER)\
+change-prompt( )"
 
FZF_TAB_BIND="tab:down,btab:up"

TS_CONTEXT="no_tmux_running"
if pgrep tmux >&/dev/null; then 
  if [ -n "$TMUX" ]; then 
    TS_CONTEXT="inside_tmux"
  else
    TS_CONTEXT="outside_tmux"
  fi
fi

FZF_COMMAND="fzf"
if [ "$TS_CONTEXT" == "inside_tmux" ]; then
  FZF_COMMAND="fzf-tmux -p"
fi

if [ "$TS_CONTEXT" != "no_tmux_running" ]; then
  SESSION_DIR=$(zoxide query -l | sed -e "$HOME_REPLACER"| $FZF_COMMAND \
    --prompt " "\
    --margin=1 --height=50% --padding=1 --reverse --border \
    --bind "$FZF_SESSIONS_BIND" \
    --bind "$FZF_ZOXIDE_BIND" \
    --bind "$FZF_PROJECT_DIRS_BIND" \
    --bind "$FZF_TAB_BIND" \
    --header "$FZF_ZOXIDE_HEADER" \
    --border-label "$FZF_ZOXIDE_BORDER_LABEL")
else 
  SESSION_DIR=$(zoxide query -l | sed -e "$HOME_REPLACER"| $FZF_COMMAND \
    --prompt " "\
    --margin=1 --height=50% --padding=1 --reverse --border \
    --bind "$FZF_ZOXIDE_BIND" \
    --bind "$FZF_PROJECT_DIRS_BIND" \
    --bind "$FZF_TAB_BIND" \
    --header "$FZF_ZOXIDE_HEADER" \
    --border-label "$FZF_ZOXIDE_BORDER_LABEL")
fi

if [ -z "$SESSION_DIR" ]; then
  exit 0
fi

if [ $HOME_SED_SAFE -eq 0 ]; then
	SESSION_DIR=$(echo "$SESSION_DIR" | sed -e "s|^~/|$HOME/|") # get real home path back
fi

SESSION_NAME=$(basename "$SESSION_DIR" | tr ' :.' '_')

if ! tmux has -t "$SESSION_NAME" &>/dev/null;  then
  tmux new-session -d -s "$SESSION_NAME" -c "$SESSION_DIR"
fi

if [ "$TS_CONTEXT" == "inside_tmux" ]; then
  tmux switch-client -t "$SESSION_NAME"
else
  tmux attach -t "$SESSION_NAME"
fi
