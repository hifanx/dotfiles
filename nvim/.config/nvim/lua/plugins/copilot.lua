return {
  'zbirenbaum/copilot.lua',
  enabled = GLOB.is_sif, -- only use on my macbook
  event = 'InsertEnter',
  cmd = 'Copilot',
  build = ':Copilot auth',
  config = function()
    require('copilot').setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
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
  end,
}
