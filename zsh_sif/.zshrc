# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# shellcheck disable=SC2296
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  # shellcheck disable=1090
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# setup homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"

# setup auto-complete, auto-suggestion, syntax-highlight
export HOMEBREW_PREFIX="/opt/homebrew/"
# shellcheck disable=SC1091
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# shellcheck disable=SC1091
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# shellcheck disable=SC1091
source $HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme
# shellcheck disable=SC1091
source $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# setup zsh-history-substring-search
bindkey '^[[A' history-substring-search-up # up arrow
bindkey '^[[B' history-substring-search-down # down arrow

# clean up $HOME directory
export LESSHISTFILE=/dev/null # stop .lesshst from generating
export ZDOTDIR=$HOME/.config/ # move .zcompdump to .config/
export HISTFILE=$HOME/.config/.zsh_history # move .zsh_history to .config/

# set EDITOR
export EDITOR='nvim'

# set $XDG PATHS
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

# homebrew
export PATH="$PATH:/usr/local/bin"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# 解决ssh到远程服务器中文乱码
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# neovim
alias cn="cd ~/.config/nvim"
alias vi="nvim"
alias vim="nvim"

## tmux
alias tn="tmux new -s"
alias tl="tmux ls"
alias td="tmux detach"
ta() {
    # Use the argument as the session name if provided, otherwise default to "WEN"
    local session_name=${1:-"WEN"}

    # Check if the session already exists
    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux attach-session -t "$session_name"
    else
        # If the session doesn't exist, create and attach to it
        tmux new-session -s "$session_name"
    fi
}

## eza
export EZA_CONFIG_DIR=$HOME/.config/eza/
alias v='eza -lag --icons auto --sort name --group-directories-first --no-quotes --no-time'
alias ll='eza -lag --icons auto --sort name --group-directories-first --no-quotes'

## personal aliases
alias cdd='cd "$HOME/.dotfiles"'
alias c="clear"
alias bu="sudo softwareupdate -ia --verbose; brew bundle -v --file=~/.dotfiles/brew/Brewfile; brew cu; brew upgrade; brew bundle dump --force --file=~/.dotfiles/brew/Brewfile --describe; brew autoremove; brew cleanup; brew doctor"
alias bi="brew bundle --verbose --force cleanup --file=~/.dotfiles/brew/Brewfile"
alias bd="brew bundle dump --force --file=~/.dotfiles/configs/brew/Brewfile --describe" 
alias lofn="ssh root@10.0.0.5"
alias heimdall="ssh root@10.0.0.1"
alias nanna="ssh xuhaifan@10.0.0.12"
alias baldur="ssh xuhaifan@10.0.0.10"

## yazi
y() {
	local tmp cwd
	tmp="$(mktemp -t 'yazi-cwd.XXXXXX')"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd" || return
	fi
	rm -f -- "$tmp"
}

# fzf
# shellcheck disable=SC1090
source <(fzf --zsh)

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# tealdeer
export TEALDEER_CONFIG_DIR=$HOME/.config/tealdeer/

# bat
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# thefuck
eval "$(thefuck --alias)"

# # conda
# eval "$(conda "shell.$(basename "${SHELL}")" hook)"

# powerlevel10k
# shellcheck disable=SC1090
[[ ! -f ~/.config/.p10k.zsh ]] || source ~/.config/.p10k.zsh
