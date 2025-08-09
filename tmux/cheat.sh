#!/usr/bin/env bash

export FZF_DEFAULT_OPTS="\
--color=spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

CHEAT_SH_URL="https://cheat.sh"

curl "$CHEAT_SH_URL/:list" 2>/dev/null | \
  fzf --reverse --no-multi | \
  xargs -I{} sh -c "curl $CHEAT_SH_URL/{} 2>/dev/null | bat --style=plain --paging=always"
