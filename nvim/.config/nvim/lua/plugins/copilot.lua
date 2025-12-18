if not GLOB.is_sif then return end

require('copilot').setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
    disable_limit_reached_message = true,
    filetypes = {
        lua = true,
        java = true,
        python = true,
        zsh = true,
        toml = true,
        yaml = true,
        markdown = true,
        help = true,
        gitcommit = true,
        gitrebase = true,
        sh = true,
        ['*'] = false, -- disable for all other filetypes and ignore default `filetypes`
    },
})
