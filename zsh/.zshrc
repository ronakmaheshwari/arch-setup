# =====================================================================
#  ~/.zshrc  —  Ronak
# =====================================================================
#
#  INSTALL EVERYTHING (Arch Linux). Run once, outside this file:
#
#    sudo pacman -S --needed \
#      fzf bat eza zoxide fd ripgrep jq yq \
#      kubectl kubectx k9s stern helm kustomize kind minikube k3d \
#      lazydocker dive trivy skopeo ctop \
#      atuin direnv lazygit git-delta btop duf dust tldr navi httpie \
#      starship tmux ttf-jetbrains-mono-nerd
#
#    AUR (via yay/paru): kubecolor hadolint-bin popeye kubeconform kubent krew
#
#  WHAT EACH TOOL DOES
#  --- Terminal essentials ---
#    fzf        fuzzy finder: Ctrl+R history, Ctrl+T files, Alt+C directories
#    bat        cat with syntax highlighting (used in fzf previews)
#    eza        modern ls with icons, git status and tree view
#    zoxide     smarter cd: "z proj" jumps to your most-used matching dir
#    fd         faster, simpler find (respects .gitignore)
#    ripgrep    very fast recursive grep (rg)
#    jq / yq    query and edit JSON / YAML on the command line
#    starship   fast, customizable prompt (git branch, k8s context...)
#    tmux       terminal multiplexer: split panes, persistent sessions
#
#  --- Kubernetes ---
#    kubectl    the official Kubernetes CLI
#    kubectx    switch clusters (contexts); kubens switches namespaces
#    k9s        full-screen terminal UI to browse/manage cluster resources
#    stern      tail logs from many pods at once by name/regex
#    kubecolor  colorizes kubectl output
#    helm       package manager for Kubernetes (charts)
#    kustomize  patch/overlay manifests without templates
#    kind       run a local cluster inside Docker containers
#    k3d        run lightweight k3s clusters in Docker (very fast)
#    minikube   run a local single-node cluster
#    krew       plugin manager for kubectl (neat, tree, view-secret...)
#    kubeconform  validate manifests against the k8s schemas
#    popeye     scan a live cluster for misconfigurations
#    kubent     find deprecated APIs before a cluster upgrade
#
#  --- Docker / containers ---
#    lazydocker TUI for containers, images, volumes, logs
#    dive       inspect image layers and find wasted space
#    ctop       live per-container CPU/memory view (like top)
#    hadolint   Dockerfile linter
#    trivy      vulnerability scanner for images, repos and manifests
#    skopeo     inspect/copy images between registries without pulling
#
#  --- Quality of life ---
#    atuin      searchable shell history database (replaces Ctrl+R UI)
#    direnv     auto-load env vars per directory (.envrc), e.g. KUBECONFIG
#    lazygit    git TUI
#    git-delta  readable, syntax-highlighted git diffs
#    btop       resource monitor    duf  disk usage table    dust  dir sizes
#    tldr       short practical command examples
#    navi       interactive cheatsheet browser
#    httpie     friendlier curl for APIs ("http" command)
# =====================================================================


# ---------------- ENV / PATH ----------------
export EDITOR=nano
# krew installs kubectl plugins to ~/.krew/bin; go binaries land in ~/go/bin
export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.krew/bin:$PATH"

# Merge several kubeconfig files (uncomment if you use more than one)
# export KUBECONFIG="$HOME/.kube/config:$HOME/.kube/config-work"

# bun (uncomment if you use it)
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"
# [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"


# ---------------- ZINIT (plugin manager) ----------------
# Downloads itself on first run, then installs plugins listed below.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"


# ---------------- PLUGINS THAT MUST LOAD BEFORE compinit ----------------
# Extra completion definitions for many CLI tools
zinit light zsh-users/zsh-completions

# Oh-My-Zsh snippets (each adds aliases and/or completions)
zinit snippet OMZL::git.zsh            # git helpers used by the git plugin
zinit snippet OMZP::git                # many git aliases (gst, gco, gl...)
zinit snippet OMZP::sudo               # press Esc twice to prepend sudo
zinit snippet OMZP::archlinux          # pacman/yay aliases (remove if not on Arch)
# zinit snippet OMZP::aws                # AWS CLI completion and helpers
zinit snippet OMZP::docker             # docker completion
zinit snippet OMZP::docker-compose     # docker compose aliases/completion
zinit snippet OMZP::kubectl            # kubectl completion + aliases (kgp, kgd, kpf...)
zinit snippet OMZP::kubectx            # kubectx/kubens prompt helpers
zinit snippet OMZP::helm               # helm completion
zinit snippet OMZP::command-not-found  # suggests which package provides a missing command


# ---------------- COMPLETION INIT ----------------
autoload -Uz compinit && compinit
zinit cdreplay -q                      # replay completions registered by zinit

# Completions generated by the tools themselves (only if installed)
command -v k9s       >/dev/null && source <(k9s completion zsh)
command -v stern     >/dev/null && source <(stern --completion zsh)
command -v kind      >/dev/null && source <(kind completion zsh)
command -v minikube  >/dev/null && source <(minikube completion zsh)
command -v k3d       >/dev/null && source <(k3d completion zsh)
command -v kustomize >/dev/null && source <(kustomize completion zsh)
command -v flux      >/dev/null && source <(flux completion zsh)
command -v trivy     >/dev/null && source <(trivy completion zsh)


# ---------------- FZF ----------------
# Key bindings: Ctrl+R (history), Ctrl+T (files), Alt+C (cd into dir)
if command -v fzf >/dev/null 2>&1; then
  if fzf --zsh >/dev/null 2>&1; then
    source <(fzf --zsh)                         # fzf 0.48+
  else
    [ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
    [ -f /usr/share/fzf/completion.zsh ]   && source /usr/share/fzf/completion.zsh
  fi
else
  echo "fzf not found. Install it: sudo pacman -S fzf"
fi

# Look: no global preview, so name pickers (containers, pods...) stay clean
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
'
# File preview only where it makes sense (Ctrl+T)
export FZF_CTRL_T_OPTS='--preview "bat --style=numbers --color=always --line-range :200 {} 2>/dev/null || ls -la {}"'
# Directory preview for Alt+C
export FZF_ALT_C_OPTS='--preview "eza -1 --color=always --icons {} 2>/dev/null || ls -la {}"'

# Use fd for fzf searches (faster, skips .git and honors .gitignore)
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# fzf-tab: replaces the Tab completion menu with an fzf popup
# (must load after compinit)
zinit light Aloxaf/fzf-tab


# ---------------- OTHER PLUGINS ----------------
# Fish-style grey suggestions from history/completions; Right-arrow accepts
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#7aa2f7"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
zinit light zsh-users/zsh-autosuggestions

# Type part of a command, then Up/Down to cycle matching history entries
zinit light zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Tells you when an alias exists for the command you just typed in full
zinit light MichaelAquilina/zsh-you-should-use

# fzf-powered git: glo (log), ga (add), gd (diff), gcf (checkout file)...
# NOTE: forgit redefines "ga". Remove this line if you prefer the plain alias below.
zinit light wfxr/forgit

# Syntax highlighting: colors commands as you type (red = invalid)
# Keep this as the LAST plugin
zinit light zsh-users/zsh-syntax-highlighting


# ---------------- COMPLETION STYLING ----------------
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case-insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # colored completion list
zstyle ':completion:*' menu no                            # let fzf-tab handle the menu
zstyle ':fzf-tab:complete:cd:*'         fzf-preview 'eza -1 --color=always --icons $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always --icons $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'                  # switch groups with < and >


# ---------------- HISTORY ----------------
HISTSIZE=50000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase
setopt appendhistory          # append instead of overwriting the file
setopt sharehistory           # share history live between terminals
setopt hist_ignore_space      # commands starting with a space aren't saved
setopt hist_ignore_all_dups   # drop older duplicates
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_reduce_blanks     # strip extra whitespace


# ---------------- TOOL INITS (only if installed) ----------------
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"                    # adds: z <dir>, zi
command -v direnv >/dev/null && eval "$(direnv hook zsh)"                    # loads .envrc per directory
command -v atuin  >/dev/null && eval "$(atuin init zsh --disable-up-arrow)"  # Ctrl+R search; Up arrow stays with substring-search
command -v navi   >/dev/null && eval "$(navi widget zsh)"                    # Ctrl+G cheatsheet picker


# ---------------- ALIASES: NAVIGATION & LISTING ----------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias t='tmux'
alias o='opencode'

alias ls='eza --icons --group-directories-first'                       # basic list
alias ll='eza -l --icons --git --group-directories-first'              # long list + git
alias la='eza -la --icons --git --group-directories-first'             # include hidden
alias lt='eza --tree --level=2 --icons'                                # tree, 2 levels
alias lta='eza --tree --all --level=2 --icons'                         # tree incl. hidden
alias lg='eza -l --git --icons'                                        # long + git status
alias ld='eza -D --icons'                                              # directories only
alias lh='eza -lh --icons --git'                                       # human-readable sizes
alias lx='eza -lah --icons --git --header --group'                     # everything, with headers


# ---------------- ALIASES: GIT / NODE ----------------
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias lgit='lazygit'           # git TUI
# alias ga='git add .'         # disabled: forgit uses "ga". Uncomment if you removed forgit.

alias nd='npm run dev'
alias nb='npm run build'
alias bd='bun run dev'


# ---------------- ALIASES: DOCKER ----------------
alias d='docker'
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'  # tidy running list
alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'          # include stopped
alias di='docker images'
alias dex='docker exec -it'                                  # dex <container> bash
alias dlogs='docker logs -f --tail 100'                      # follow last 100 lines
alias dstop='docker stop $(docker ps -q)'                    # stop all running containers
alias dprune='docker system prune -af --volumes'             # DELETES all unused images/volumes
alias dcu='docker compose up -d'                             # start stack in background
alias dcd='docker compose down'                              # stop and remove stack
alias dcl='docker compose logs -f --tail 100'                # follow compose logs
alias dcr='docker compose restart'
alias dcb='docker compose up -d --build'                     # rebuild and start
alias lzd='lazydocker'                                       # Docker TUI
alias ctp='ctop'                                             # live container resource usage

# ---------------- ALIASES: KUBERNETES ----------------
# Colorize kubectl if kubecolor is installed; "k" then goes through it too
command -v kubecolor >/dev/null && { alias kubectl='kubecolor'; compdef kubecolor=kubectl; }
alias k='kubectl'
alias kctx='kubectx'                                         # switch cluster
alias kns='kubens'                                           # switch namespace
alias kp='kubectl get pods'
alias kgpw='kubectl get pods -w'                             # watch pods
alias kgpa='kubectl get pods -A'                             # pods in all namespaces
alias kgn='kubectl get nodes -o wide'
alias kge='kubectl get events --sort-by=.lastTimestamp'      # recent events last
alias ktp='kubectl top pods'                                 # pod CPU/memory (needs metrics-server)
alias ktn='kubectl top nodes'
alias kx='kubectl exec -it'                                  # kx <pod> -- sh
alias klf='kubectl logs -f --tail=100'
alias kdel='kubectl delete'
alias kroll='kubectl rollout restart'                        # kroll deploy/<name>
alias kwhoami='kubectl config view --minify -o jsonpath="{.current-context} / {..namespace}{\"\n\"}"'  # current ctx/ns
alias h='helm'
alias k9='k9s'                                               # cluster TUI
alias tf='terraform'
alias kdry='kubectl --dry-run=client -o yaml'                # generate YAML: kdry run x --image=nginx
alias kapply='kubectl apply -f'
alias kdiff='kubectl diff -f'                                # preview changes before apply


# ---------------- REMOVE PLUGIN ALIASES THAT CLASH WITH FUNCTIONS ----------------
# Zsh expands aliases while parsing, so "kpf() {" fails if an alias named kpf
# exists (the OMZ kubectl plugin defines one). This must be its own line,
# executed BEFORE the function definitions below.
unalias dsh dlg drm dimg dscan \
        kc kn ksh klg kpf ksec kdesc krestart kdebug ksl 2>/dev/null


# ---------------- FUNCTIONS: DOCKER (fzf-powered) ----------------
# dsh: pick a running container and open a shell in it (bash if present, else sh)
dsh() {
  local c
  c=$(docker ps --format '{{.Names}}' | fzf --prompt='container> ') || return
  docker exec -it "$c" sh -c 'command -v bash >/dev/null && exec bash || exec sh'
}

# dlg: pick a container and follow its logs
dlg() {
  local c
  c=$(docker ps --format '{{.Names}}' | fzf --prompt='logs> ') || return
  docker logs -f --tail 200 "$c"
}

# drm: multi-select (Tab) containers and force-remove them
drm() {
  docker ps -a --format '{{.Names}}\t{{.Status}}' | fzf -m --prompt='rm> ' \
    | cut -f1 | xargs -r docker rm -f
}

# dimg: inspect an image's layers with dive
dimg() {
  local i
  i=$(docker images --format '{{.Repository}}:{{.Tag}}' | fzf --prompt='image> ') || return
  dive "$i"
}

# dscan: pick a local image and scan it for vulnerabilities with trivy
dscan() {
  local i
  i=$(docker images --format '{{.Repository}}:{{.Tag}}' | fzf --prompt='scan> ') || return
  trivy image "$i"
}


# ---------------- FUNCTIONS: KUBERNETES (fzf-powered) ----------------
# kc: pick and switch cluster context
kc() {
  local c
  c=$(kubectl config get-contexts -o name | fzf --prompt='context> ') || return
  kubectl config use-context "$c"
}

# kn: pick and switch default namespace
kn() {
  local n
  n=$(kubectl get ns -o name | cut -d/ -f2 | fzf --prompt='namespace> ') || return
  kubectl config set-context --current --namespace="$n"
}

# ksh: pick a pod and open a shell in it
ksh() {
  local p
  p=$(kubectl get pods --no-headers | fzf --prompt='pod> ' | awk '{print $1}') || return
  [ -n "$p" ] || return
  kubectl exec -it "$p" -- sh -c 'command -v bash >/dev/null && exec bash || exec sh'
}

# klg: pick a pod and follow its logs
klg() {
  local p
  p=$(kubectl get pods --no-headers | fzf --prompt='logs> ' | awk '{print $1}') || return
  [ -n "$p" ] || return
  kubectl logs -f --tail=200 "$p"
}

# kpf: pick a pod and port-forward. Usage: kpf 8080:80
kpf() {
  local p
  p=$(kubectl get pods --no-headers | fzf --prompt='forward> ' | awk '{print $1}') || return
  [ -n "$p" ] || return
  kubectl port-forward "$p" "${1:-8080:80}"
}

# ksec: pick a secret and print its decoded values
ksec() {
  local s
  s=$(kubectl get secrets -o name | fzf --prompt='secret> ') || return
  kubectl get "$s" -o json | jq '.data | map_values(@base64d)'
}

# kdesc: pick a pod and describe it (events, probes, restarts)
kdesc() {
  local p
  p=$(kubectl get pods --no-headers | fzf --prompt='describe> ' | awk '{print $1}') || return
  [ -n "$p" ] || return
  kubectl describe pod "$p" | ${PAGER:-less}
}

# krestart: pick a deployment and rolling-restart it
krestart() {
  local d
  d=$(kubectl get deploy -o name | fzf --prompt='restart> ') || return
  kubectl rollout restart "$d"
}

# kdebug: start a throwaway debug pod with network tools (deleted on exit)
kdebug() {
  kubectl run "debug-$RANDOM" --rm -it --image=nicolaka/netshoot -- bash
}

# ksl: stern across pods matching a name. Usage: ksl <pod-name-part>
ksl() { stern "${1:?usage: ksl <pod-name-regex>}" --tail 50; }


# ---------------- STARSHIP PROMPT (keep last) ----------------
if command -v starship >/dev/null; then
  # Generate the pastel-powerline preset once, if no config exists yet
  if [ ! -f "$HOME/.config/starship.toml" ]; then
    mkdir -p "$HOME/.config"
    starship preset pastel-powerline -o "$HOME/.config/starship.toml"
  fi
  eval "$(starship init zsh)"
fi
