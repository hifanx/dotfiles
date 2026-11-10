# Why this file exists (do not remove):
# - Read by every zsh, incl. non-interactive (scripts, `zsh -c`, editors, agents);
#   .zshrc isn't, so tools would miss these vars and pollute ~ (~/.npm, ~/.cargo, ~/.claude...).
# - SHELL_SESSIONS_DISABLE must be set before /etc/zshrc_Apple_Terminal.
# PATH is re-ordered in .zshrc (path_helper); HISTFILE lives there (/etc/zshrc resets it).

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# locale
export LANG=en_US.UTF-8

# editor
export EDITOR='nvim'

# npm
export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_TMP="$XDG_CACHE_HOME/npm/tmp"
export NPM_CONFIG_LOGS_DIR="$XDG_DATA_HOME/npm/logs"

# cargo
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# Tool configuration
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
export MPLCONFIGDIR="$XDG_CACHE_HOME/matplotlib"
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"
export TEALDEER_CONFIG_DIR="$XDG_CONFIG_HOME/tealdeer"
export PI_CODING_AGENT_DIR="$XDG_CONFIG_HOME/pi"
export PI_TELEMETRY=0
export PI_WEB_ACCESS_CACHE_ROOT="$XDG_CACHE_HOME/pi-web-access"
export LESSHISTFILE=/dev/null

# Must precede /etc/zshrc_Apple_Terminal.
export SHELL_SESSIONS_DISABLE=1

# Homebrew environment without invoking brew for every shell.
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"

# Make Mason, Homebrew, Cargo, and npm available in every shell without duplicates.
typeset -U path
path=(
    "$XDG_DATA_HOME/nvim/mason/bin"
    "$HOMEBREW_PREFIX/bin"
    "$HOMEBREW_PREFIX/sbin"
    "$CARGO_HOME/bin"
    "$NPM_CONFIG_PREFIX/bin"
    "${path[@]}"
)
export PATH
