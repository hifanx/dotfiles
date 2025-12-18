-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has('win32') ~= 0
local sep = is_windows and '\\' or '/'
local delim = is_windows and ';' or ':'
vim.env.PATH = table.concat({ vim.fn.stdpath('data'), 'mason', 'bin' }, sep) .. delim .. vim.env.PATH

vim.keymap.set('n', '<leader>hm', ':Mason<CR>', { desc = '[M]ason' })

require('mason').setup({})

local ensure_installed = {
    'tree-sitter-cli',
    -- LSP servers
    'css-lsp',
    'lua-language-server',
    'yaml-language-server',
    'json-lsp',
    'markdown-oxide',
    'taplo',
    'pyright',
    'docker-language-server',
    'bash-language-server',
    -- Formatters
    'stylua',
    'prettier',
    'shfmt',
    'black',
    -- Linters
    'shellcheck', -- used by shfmt
}

local function auto_install_missing_tools()
    local mr = require('mason-registry')

    mr.refresh(function()
        local to_install = {}

        local show = vim.schedule_wrap(function(msg) vim.notify(msg, vim.log.levels.INFO, { title = 'Mason' }) end)
        local show_error = vim.schedule_wrap(
            function(msg) vim.notify(msg, vim.log.levels.ERROR, { title = 'Mason' }) end
        )

        local function do_install(p)
            p:once('install:success', function() show(string.format('%s: successfully installed', p.name)) end)
            p:once('install:failed', function() show_error(string.format('%s: failed to install', p.name)) end)
            if not p:is_installing() then
                show(string.format('Installing %s', p.name))
                p:install()
            end
        end

        for _, name in ipairs(ensure_installed) do
            if not mr.is_installed(name) then table.insert(to_install, name) end
        end

        if #to_install > 0 then
            for _, name in ipairs(to_install) do
                local p = mr.get_package(name)
                do_install(p)
            end
        end
    end)
end

vim.defer_fn(function() auto_install_missing_tools() end, 100)
