-- bootstrap plugin specs
LAZY_PLUGIN_SPEC = {}
function spec(item) table.insert(LAZY_PLUGIN_SPEC, { import = item }) end

-- set default options
require "core.options"

-- load mappings
require "core.keymaps"

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ ESSENTIALS                                            │
-- ╰──────────────────────────────────────────────────────────╯
spec "plugins.blink"
spec "plugins.conform"
spec "plugins.mason"
spec "plugins.nvim-lint"
spec "plugins.nvim-treesitter"
spec "plugins.which-key"

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ EDITOR                                                │
-- ╰──────────────────────────────────────────────────────────╯
spec "plugins.better-escape"
spec "plugins.carbon-now" -- screenshot code
spec "plugins.gitsigns"
spec "plugins.inc-rename" -- LSP renaming with immediate visual feedback
spec "plugins.noice" -- used to redirect messages to vim.notify e.g. xx lines written/yanked
spec "plugins.nvim-autopairs"
spec "plugins.nvim-surround"
spec "plugins.nvim-ts-autotag"
spec "plugins.pangu" -- auto format to add a space between cjk and english letters
spec "plugins.snacks"
spec "plugins.ts-comments" -- enhance neovim's native comments, neovim natively supports comment now
spec "plugins.vim-tmux-navigator"
spec "plugins.vim-oscyank" -- yank text even from remote

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ UI                                                    │
-- ╰──────────────────────────────────────────────────────────╯
spec "plugins.catppuccin"
spec "plugins.barbecue" -- VS Code like winbar  WARN: REPO ARCHIVED
spec "plugins.lualine"
spec "plugins.nvim-colorizer"
spec "plugins.render-markdown"
spec "plugins.todo-comments"
spec "plugins.smear-cursor" -- animated cursor

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ AI                                                    │
-- ╰──────────────────────────────────────────────────────────╯
spec "plugins.avante"
spec "plugins.copilot"

-- bootstrap lazy
require "core.lazy"

-- load lsp
require "core.lsp"

-- load autocmd
require "core.autocmd"

-- set colorscheme
vim.cmd [[colorscheme catppuccin]]
