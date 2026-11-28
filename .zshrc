# shellcheck disable=SC2296,SC1090,SC1091,SC2086,SC2016,SC2154,SC1087,SC2034,SC2206

# p10k instant prompt: keep near the top; anything needing console input goes above.
[[ -r $XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh ]] && source $XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh

setopt ignoreeof # ctrl+d won't kill the pane

# /etc/zprofile runs path_helper after .zshenv; restore command precedence.
path=($XDG_DATA_HOME/nvim/mason/bin $HOMEBREW_PREFIX/{bin,sbin} $CARGO_HOME/bin $NPM_CONFIG_PREFIX/bin $path)
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath) # brew completions; /bin/zsh lacks them

# zinit auto-installs itself and plugins. Update: zinit self-update; zinit update --parallel
ZINIT_HOME=$XDG_DATA_HOME/zinit/zinit.git
[[ -d $ZINIT_HOME/.git ]] || git clone --depth=1 https://github.com/zdharma-continuum/zinit.git $ZINIT_HOME
source $ZINIT_HOME/zinit.zsh

# vi mode: explicit (not via $EDITOR) and before plugins, so zsh-autocomplete binds into viins
bindkey -v
KEYTIMEOUT=1 # Esc switches mode instantly instead of waiting 0.4s for an Alt-chord

# zsh-autocomplete's zasync loader leaves a dead stub unless zasync is already on fpath (upstream bug)
fpath+=($XDG_CACHE_HOME/zsh/zasync)
# syntax-highlighting must load last (its docs)
zinit light-mode depth"1" for \
    romkatv/powerlevel10k \
    zsh-users/zsh-completions \
    marlonrichert/zsh-autocomplete \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-syntax-highlighting

# HISTFILE here, not .zshenv: macOS /etc/zshrc resets it after .zshenv.
HISTFILE=$XDG_CACHE_HOME/zsh/.zsh_history
HISTSIZE=5000 SAVEHIST=5000
setopt share_history hist_ignore_space hist_ignore_all_dups

bindkey '^y' autosuggest-accept
bindkey '^p' history-search-backward # match on first word (e.g. `cd`)
bindkey '^n' history-search-forward
# Tab/Shift-Tab open the zsh-autocomplete menu, then cycle inside it
bindkey '^I' menu-select
bindkey "$terminfo[kcbt]" menu-select
bindkey -M menuselect '^I' menu-complete
bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete

# neovim
alias cn="cd ~/.config/nvim"
alias vi="nvim"
alias vim="nvim"

# eza
alias v='eza -lag --icons auto --group-directories-first --no-quotes --no-time --git --header'
alias ll='eza -lag --icons auto --group-directories-first --no-quotes --git --header --time-style long-iso --total-size'
alias tt='eza -T -L 2 --icons auto --git-ignore --no-quotes'

# personal aliases
alias bu="sudo softwareupdate -ia --verbose; brew bundle -v --global; brew cu; brew upgrade; brew autoremove; brew cleanup; brew doctor"
alias bi="brew bundle --verbose --force cleanup --global"
alias bd="brew bundle dump --force --global"
alias lofn="ssh root@10.0.0.5"
alias heimdall="ssh root@10.0.0.1"
alias yggdrasil="ssh root@10.0.0.2"
alias baldur="ssh xuhaifan@10.0.0.10"
alias idun="ssh xuhaifan@10.0.0.11"
alias nanna="ssh xuhaifan@10.0.0.12"
# lofn SMB shares (appdata, data, fast): nas [share...] / unas [share...]
nas() { for s in "${@:-data}"; do osascript -e "mount volume \"smb://Lofn._smb._tcp.local/$s\"" >/dev/null && echo "/Volumes/$s"; done; }
unas() { for s in "${@:-data}"; do diskutil unmount "/Volumes/$s"; done; }
alias co='cd "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obsidian"'
alias g='lazygit'
alias ly='yadm enter lazygit'
alias oc='opencode'
alias ds='find ~ -type f -name ".DS_Store" -delete'

# yazi: cd into the dir yazi exits in
y() {
    local tmp cwd
    tmp="$(mktemp -t yazi-cwd.XXXXXX)" || return
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd <"$tmp"
    command rm -f -- "$tmp"
    if [[ $cwd != "$PWD" && -d $cwd ]]; then
        builtin cd -- "$cwd" || return
    fi
}

# fzf
export FZF_DEFAULT_OPTS='--height 50% --layout reverse --border --info inline-right --bind ctrl-/:toggle-preview'
export FZF_CTRL_T_COMMAND='fd --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :300 {} 2>/dev/null || eza -T -L 2 --icons always --color always {}'"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="--preview 'eza -T -L 2 --icons always --color always {}'"
export FZF_CTRL_R_OPTS="--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'ctrl-y: copy'"
_fzf_compgen_path() { fd --hidden --follow --exclude .git . "$1"; } # **<Tab> uses fd
_fzf_compgen_dir() { fd --type d --hidden --follow --exclude .git . "$1"; }
source <(fzf --zsh)

eval "$(zoxide init --cmd cd zsh)"

alias -g -- --help='--help 2>&1 | bat --language=help --style=plain' # colorize --help via bat

[[ -f $XDG_CONFIG_HOME/.env ]] && source $XDG_CONFIG_HOME/.env

[[ -n $HERDR_TAB_ID$HERDR_SOCKET_PATH ]] && export TERM=xterm-ghostty

# p10k configure writes to ${POWERLEVEL9K_CONFIG_FILE:-${ZDOTDIR:-~}/.p10k.zsh}; pin it.
typeset -g POWERLEVEL9K_CONFIG_FILE=$XDG_CONFIG_HOME/zsh/p10k.zsh
[[ -f $POWERLEVEL9K_CONFIG_FILE ]] && source $POWERLEVEL9K_CONFIG_FILE

# Re-patch Krita's bundled Python after app updates to keep ~/.matplotlib clean (GUI apps don't get .zshenv).
krita-fix() {
    local f=/Applications/Krita.app/Contents/Frameworks/Python.framework/Versions/3.13/lib/python3.13/sitecustomize.py
    [[ -f $f ]] || {
        echo "Krita not found at expected path"
        return 1
    }
    grep -q MPLCONFIGDIR "$f" && {
        echo "already patched"
        return
    }
    printf '\nimport os\nos.environ.setdefault("MPLCONFIGDIR", os.path.expanduser("~/.cache/matplotlib"))\n' >>"$f"
    echo "patched"
}
