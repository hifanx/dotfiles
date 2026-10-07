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
export NPM_CONFIG_PREFIX="$HOME/.local/share/npm"
export NPM_CONFIG_CACHE="$HOME/.cache/npm"
export NPM_CONFIG_TMP="$HOME/.cache/npm/tmp"
export NPM_CONFIG_LOGS_DIR="$HOME/.cache/npm/logs"

# cargo
export CARGO_HOME="$HOME/.local/share/cargo"

# Tool configuration
export MPLCONFIGDIR="$HOME/.cache/matplotlib"
export EZA_CONFIG_DIR="$HOME/.config/eza"
export TEALDEER_CONFIG_DIR="$HOME/.config/tealdeer"
export PI_CODING_AGENT_DIR="$HOME/.config/pi"
export PI_TELEMETRY=0
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
    $path
)
export PATH
