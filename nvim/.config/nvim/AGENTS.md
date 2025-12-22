# Agent Guidelines for Neovim Configuration

## Scope

- These guidelines apply to this Neovim config directory and all files under it

## Philosophy: Minimal Configuration

**This Neovim config prioritizes minimalism above all else.**

- Only add features that are absolutely necessary
- Prefer built-in Neovim functionality over plugins when possible
- Remove plugins/features that duplicate existing functionality
- Keep the configuration lean, fast, and maintainable
- Question every addition: "Do we really need this?"

## Build/Lint/Test Commands

- **Format Lua**: `stylua .` (config: `stylua.toml` - 120 cols, 4 spaces, Unix endings, single quotes)
- **Check config**: `nvim --headless "+Lazy! sync" +qa` (sync plugins)
- No formal test suite - test changes by launching `nvim` and verifying functionality

## Code Style Guidelines

### File Structure

- Use fold markers `{{{` and `}}}` to organize code sections
- Main config in `init.lua`, plugins in `lua/plugins/*.lua`, LSP configs in `lsp/*.lua`

### Colors & Highlights

- Define shared colors in `lua/palette.lua`
- Configure highlight groups in `colors/isekai.lua`

### Lua Conventions

- **Indentation**: 2 spaces, no tabs
- **Line length**: 120 characters max
- **Quotes**: Single quotes preferred (auto-prefer via stylua)
- **Function calls**: Always use parentheses (stylua: `call_parentheses = "Always"`)
- **Naming**: snake_case for variables/functions, PascalCase for classes/types

### Comments & Documentation

- Use box comments with unicode for major sections (see init.lua examples)
- Inline comments with `--` for brief explanations, `NOTE:` prefix for important notes

### Imports & Dependencies

- Load plugins lazily via lazy.nvim (`event`, `cmd`, `keys`, etc.)
- Use `require()` only when needed, prefer `init` for keymaps
- Global utilities live in the `_G.GLOB` namespace (see the top of `init.lua` for definitions)
- Before adding a new plugin, check if Neovim already provides the functionality

### Plugin Guidelines

- **Avoid bloat**: Only include plugins that provide significant value
- **Lazy loading**: All plugins must be lazy-loaded appropriately
- **No duplicates**: Remove plugins with overlapping functionality
- **Native first**: Use Vim/Neovim built-ins before reaching for plugins
- **Performance**: Profile impact before adding heavy plugins

### Error Handling

- Validate with `if not client then return end` pattern
- Use `vim.notify()` with log levels for user-facing messages

## Assistant Workflow

- Prefer editing existing files over creating new ones
- Avoid adding new plugins unless explicitly requested
- Run `stylua .` after modifying Lua files when practical
- Do not edit `nvim-pack-lock.json` by hand
- Keep changes small, focused, and easy to revert
