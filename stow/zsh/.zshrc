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
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

export FZF_DEFAULT_OPTS='
--height 40%
--layout=reverse
--border
--preview "bat --style=numbers --color=always {} 2>/dev/null || ls -la {}"
'

# ---------------- AUTOSUGGESTIONS ----------------
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#7aa2f7"
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# ---------------- SYNTAX HIGHLIGHTING ----------------
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# ---------------- ALIASES ----------------
alias ll='ls -la --color=auto'
alias gs='git status'
alias ga='git add .'
alias gc='git commit'
alias gp='git push origin HEAD'
alias nd='npm run dev'
alias nb='npm run build'
alias d='docker'
alias k='kubectl'
alias ..='cd ..'
alias ...='cd ../..'

# eza aliases
alias ls='eza --icons'
alias lsa='eza -a --icons'
alias lt='eza --tree --level=2 --icons'
alias lta='eza -a --tree --level=2 --icons'


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

# zinit light Aloxaf/fzf-tab

# # Completion styling
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# zstyle ':completion:*' menu no
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
# zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

. "$HOME/.local/share/../bin/env"
export PATH="$HOME/.local/bin:$PATH"
