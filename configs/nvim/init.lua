-- bootstrap plugin specs
LAZY_PLUGIN_SPEC = {}
function spec(item) table.insert(LAZY_PLUGIN_SPEC, { import = item }) end

-- set default options
require "core.options"

-- load mappings
require "core.keymaps"

-- load autocmd
require "core.autocmd"

---------------------
-- ESSENTIALS
---------------------
spec "plugin.nvim-treesitter"
-- spec "plugin.telescope" -- TODO:
spec "plugin.which-key"
spec "plugin.blink" -- TODO:
spec "plugin.conform"
spec "plugin.nvim-lint"
spec "plugin.nvim-lspconfig" -- TODO:
-- spec "plugin.nvim-dap" -- TODO:
---------------------
-- EDITOR
---------------------
spec "plugin.mini" -- TODO:
spec "plugin.gitsigns"
spec "plugin.vim-tmux-navigator"
spec "plugin.carbon-now" -- screenshot code
spec "plugin.pangu" -- auto format to add a space between cjk and english letters
spec "plugin.nvim-ts-autotag"
spec "plugin.vim-oscyank" -- yank text even from remote
spec "plugin.ts-comments" -- enhance neovim's native comments, neovim natively supports comment now
spec "plugin.snacks" -- TODO:
spec "plugin.better-escape"

---------------------
-- UI
---------------------
spec "plugin.barbecue" -- VS Code like winbar
spec "plugin.lualine"
spec "plugin.nvim-colorizer"
spec "plugin.render-markdown"
spec "plugin.todo-comments"
spec "plugin.catppuccin" -- TODO:
spec "plugin.smear-cursor" -- animated cursor

-- bootstrap lazy
require "core.lazy"

-- setup highlights
require "core.highlights"

vim.cmd [[colorscheme catppuccin]]
