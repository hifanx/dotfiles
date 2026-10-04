vim.keymap.set('n', '<leader>hm', ':Mason<CR>', { desc = 'Mason' })

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
    'google-java-format',
    -- Linters
    'shellcheck', -- used by bashls
}

local function auto_install_missing_tools()
    local mr = require('mason-registry')

    local to_install = {}
    for _, name in ipairs(ensure_installed) do
        if not mr.is_installed(name) then table.insert(to_install, name) end
    end
    if #to_install == 0 then return end

    local show = vim.schedule_wrap(function(msg) vim.notify(msg, vim.log.levels.INFO, { title = 'Mason' }) end)
    local show_error = vim.schedule_wrap(function(msg) vim.notify(msg, vim.log.levels.ERROR, { title = 'Mason' }) end)

    local function do_install(p)
        p:once('install:success', function() show(string.format('%s: successfully installed', p.name)) end)
        p:once('install:failed', function() show_error(string.format('%s: failed to install', p.name)) end)
        if not p:is_installing() then
            show(string.format('Installing %s', p.name))
            p:install()
        end
    end

    mr.refresh(function()
        for _, name in ipairs(to_install) do
            do_install(mr.get_package(name))
        end
    end)
end

vim.defer_fn(function() auto_install_missing_tools() end, 100)
