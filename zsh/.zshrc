# ---------------- ZINIT ----------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# ---------------- STARSHIP ----------------
eval "$(starship init zsh)"

# ---------------- FZF ----------------
# Auto-install fzf if not present
if ! command -v fzf >/dev/null 2>&1; then
  echo "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
fi

[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
zinit light Aloxaf/fzf-tab

export FZF_DEFAULT_OPTS='
--height 40%
--layout=reverse
--border
--preview "bat --style=numbers --color=always {} 2>/dev/null || ls -++++la {}"
'

# ---------------- AUTOSUGGESTIONS ----------------
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#7aa2f7"

# Auto-load via zinit (downloads if missing)
zinit light zsh-users/zsh-autosuggestions

# ---------------- SYNTAX HIGHLIGHTING ----------------
# Auto-load via zinit (downloads if missing)
zinit light zsh-users/zsh-syntax-highlighting

# ---------------- ENV ----------------
export EDITOR=nano

# ---------------- TMUX ----------------
# tmux is started manually (no default session)
#if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
#    tmux attach -t main || tmux new -s main
#fi

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# ---------------- ALIASES ----------------
alias ll='ls -la --color=auto'
alias gs='git status'
alias ga='git add .'
alias gc='git commit'
alias gp='git push'
alias nd='npm run dev'
alias nb='npm run build'
alias bd='bun run dev'
alias t='tmux'
alias d='docker'
alias k='kubectl'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias l='lazydocker'
alias ls="eza --icons --group-directories-first"
alias ll="eza -l --icons --git --group-directories-first"
alias la="eza -la --icons --git --group-directories-first"
alias lt="eza --tree --level=2 --icons"
alias lta="eza --tree --all --level=2 --icons"
alias lg="eza -l --git --icons"
alias ld="eza -D --icons"
alias lh="eza -lh --icons --git"
alias lx="eza -lah --icons --git --header --group"

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# bun completions
#[ -s "/home/ronak/.bun/_bun" ] && source "/home/ronak/.bun/_bun"

# bun
#export BUN_INSTALL="$HOME/.bun"
#export PATH="$BUN_INSTALL/bin:$PATH"
