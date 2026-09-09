local ensure_installed_ts = {
    'c',
    'lua',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
    'diff',
    -- NOTE: the above are natively installed since neovim 0.13
    'bash',
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
    'latex',
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

-- NOTE: pcall is necessary — vim.treesitter.start asserts (not just errors) when language
-- detection fails on filetype-only buffers with no file path (e.g. fzf-lua diff previews).
local ts_start = function(ev) pcall(vim.treesitter.start, ev.buf) end

-- NOTE: Do not use "*" here — the filetypes list is intentional and explicit.
-- Using "*" would start treesitter for every filetype, including ones with no parser,
-- causing errors and unnecessary overhead.
vim.api.nvim_create_autocmd('FileType', {
    desc = 'Start treesitter',
    group = vim.api.nvim_create_augroup('start_treesitter', { clear = true }),
    pattern = filetypes,
    callback = ts_start,
})

require('nvim-treesitter').setup()
