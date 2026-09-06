# shellcheck disable=SC2296,SC1090,SC1091,SC2086,SC2016,SC2154,SC1087
# .zshenv - Environment variables for all zsh contexts
# Loaded by login shells, interactive shells, scripts, and GUI app subprocesses

# XDG Base Directory Specification
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache

# Locale (solves cjk gibberish)
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Editor
export EDITOR='nvim'

# npm - consolidated XDG-compliant paths
export NPM_CONFIG_PREFIX="$HOME/.local/share/npm"
export NPM_CONFIG_CACHE="$HOME/.cache/npm"
export NPM_CONFIG_TMP="$HOME/.cache/npm/tmp"
export NPM_CONFIG_LOGS_DIR="$HOME/.cache/npm/logs"
export NODE_PATH="$NPM_CONFIG_PREFIX/lib/node_modules"

# Cargo (Rust)
export CARGO_HOME="$HOME/.local/share/cargo"

# Python/matplotlib (for Krita AI diffusion plugin)
export MPLCONFIGDIR="$HOME/.cache/matplotlib"

# Tool configs
export EZA_CONFIG_DIR=$HOME/.config/eza/
export TEALDEER_CONFIG_DIR=$HOME/.config/tealdeer/

# OpenCode
export BUN_INSTALL="$HOME/.local/share/opencode/"
export BUN_INSTALL_CACHE_DIR="$HOME/.local/share/opencode/cache"

# PATH - Cargo binaries before npm globals
export PATH="$CARGO_HOME/bin:$NPM_CONFIG_PREFIX/bin:$PATH"
