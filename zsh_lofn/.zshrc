# shellcheck disable=SC1073,SC1090,SC1091,SC2296,SC2034
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH=/mnt/user/appdata/zsh/.oh-my-zsh
export HISTFILE=/mnt/user/appdata/zsh/.zsh_history
if [ ! "$TMUX" = "" ]; then export TERM=xterm-256color; fi

export ZSH_THEME="powerlevel10k/powerlevel10k"
export ZSH_DISABLE_COMPFIX=true
zstyle ':omz:update' mode auto      # update automatically without asking

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# set $XDG PATHS
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

# 解决ssh到远程服务器中文乱码
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# set EDITOR
export EDITOR='vim'

# neovim
alias cn="cd ~/.config/nvim"

## personal aliases
alias c="clear"
alias v="ls -alh"
alias cda="cd /mnt/user/appdata/"
alias cdd="cd /mnt/user/data/"
alias cdf="cd /mnt/disks/fast/"
alias cho="chown -R nobody:users"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
