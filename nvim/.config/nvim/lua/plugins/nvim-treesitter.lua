GLOB.timer.start('nvim-treesitter')
local ensure_installed_ts = {
    'c',
    'lua',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
    -- NOTE: the above are natively installed since neovim 0.12
    'bash',
    'diff',
    'dockerfile',
    'gitignore',
    'git_config',
    'luadoc',
    'regex',
    'toml',
    'yaml',
    'csv',
    'java',
    'python',
    'html',
    'css',
    'javascript',
    'typescript',
    'json',
}

local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
local to_install = vim.tbl_filter(isnt_installed, ensure_installed_ts)
if #to_install > 0 then require('nvim-treesitter').install(to_install) end

-- Ensure tree-sitter enabled after opening a file for target language
local filetypes = {}
for _, lang in ipairs(ensure_installed_ts) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
        table.insert(filetypes, ft)
    end
end
local ts_start = function(ev) vim.treesitter.start(ev.buf) end

-- WARN: Do not use "*" here - snacks.nvim is buggy and vim.notify triggers FileType events internally causing infinite callback loops
vim.api.nvim_create_autocmd('FileType', {
    desc = 'Start treesitter',
    group = vim.api.nvim_create_augroup('start_treesitter', { clear = true }),
    pattern = filetypes,
    callback = ts_start,
})

require('nvim-treesitter').setup()

GLOB.timer.stop('nvim-treesitter')
