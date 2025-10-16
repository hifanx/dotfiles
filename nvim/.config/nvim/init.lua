-- bootstrap plugin specs
LAZY_PLUGIN_SPEC = {}
function spec(item) table.insert(LAZY_PLUGIN_SPEC, { import = item }) end

-- set default options
require 'core.options'

-- load mappings
require 'core.keymaps'

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ ESSENTIALS                                            │
-- ╰──────────────────────────────────────────────────────────╯
spec 'plugins.blink' -- completion
spec 'plugins.conform' -- format
spec 'plugins.mason' -- auto install lsp, formatter, linter
spec 'plugins.nvim-lint' -- linting
spec 'plugins.nvim-treesitter' -- syntax highlighting
spec 'plugins.snacks' -- to be deleted

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ EDITOR                                                │
-- ╰──────────────────────────────────────────────────────────╯
spec 'plugins.better-escape'
spec 'plugins.nvim-autopairs'
spec 'plugins.nvim-surround'
spec 'plugins.nvim-ts-autotag'
spec 'plugins.pangu' -- auto format to add a space between cjk and english letters
spec 'plugins.ts-comments' -- enhance neovim's native comments

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ Tools                                                 │
-- ╰──────────────────────────────────────────────────────────╯
spec 'plugins.carbon-now' -- screenshot code
spec 'plugins.inc-rename' -- LSP renaming with immediate visual feedback
spec 'plugins.vim-tmux-navigator'
spec 'plugins.which-key'
spec 'plugins.persistence' -- session manager

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ UI                                                    │
-- ╰──────────────────────────────────────────────────────────╯
spec 'plugins.catppuccin'
spec 'plugins.gitsigns'
spec 'plugins.lualine'
spec 'plugins.mini-icons'
spec 'plugins.nvim-colorizer'
spec 'plugins.render-markdown'
spec 'plugins.smear-cursor' -- animated cursor
spec 'plugins.todo-comments'

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ AI                                                    │
-- ╰──────────────────────────────────────────────────────────╯
spec 'plugins.avante'
spec 'plugins.copilot'

-- bootstrap lazy
require 'core.lazy'

-- load lsp
require 'core.lsp'

-- load autocmd
require 'core.autocmd'

-- set colorscheme
vim.cmd [[colorscheme catppuccin]]
