# shellcheck disable=SC2296,SC1090,SC1091,SC2086,SC2016,SC2154,SC1087
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then 
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" 
fi

# setup homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_PREFIX="/opt/homebrew/"
# configure mirrors
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"

#  NOTE: use zinit because it automatically installs what I need
#  https://www.youtube.com/watch?v=ud7YxC33Z3w
#  ice = append args to the install command, aka 'git'
#  light = zinit's install command, meaning load without reporting/investigating.
#  Self update: zinit self-update
#  Plugin update: zinit update
#  Plugin parallel update: zinit update --parallel
#  Increase the number of jobs in a concurrent-set to 40: zinit update --parallel 40
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# install plugins
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions # this adds additional completion definitions 
zinit light marlonrichert/zsh-autocomplete # this adds real-time type-ahead autocompletion
zinit light zsh-users/zsh-autosuggestions

# clean up $HOME directory, also needed for plugins to work across sessions
export LESSHISTFILE=/dev/null # stop .lesshst from generating
export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$ZSH_VERSION" # move .zcompdump to cache
export HISTFILE=$HOME/.cache/zsh/.zsh_history # move .zsh_history to cache
export HISTSIZE=5000
export SAVEHIST=$HISTSIZE
export ISTDUP=erase # erase duplicates
setopt appendhistory # append rather than writing
setopt sharehistory # for cross sessions
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# zsh-autosuggestions
bindkey '^y' autosuggest-accept
# needed when: type cd, it only shows commands match that prefix
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# zsh-completions
# autoload -Uz compinit && compinit # load completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # use color for completions

# zsh-autocomplete
bindkey              '^I'         menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete
bindkey              '^I' menu-select
bindkey "$terminfo[kcbt]" menu-select

# general config
export EDITOR='nvim'
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

#  FIX: gibberish for cjk characters
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# neovim
export NVIM_PROFILE="sif"
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
alias bd="brew bundle dump --force --file=~/.dotfiles/brew/Brewfile --describe" 
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
source <(fzf --zsh)

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# tealdeer
export TEALDEER_CONFIG_DIR=$HOME/.config/tealdeer/

# bat
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# thefuck
eval "$(thefuck --alias)"

# secrets
if [ -f ~/.config/.secrets ]; then
    source ~/.config/.secrets
fi

# powerlevel10k
[[ ! -f ~/.config/.p10k.zsh ]] || source ~/.config/.p10k.zsh
