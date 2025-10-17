return {
  'zbirenbaum/copilot.lua',
  enabled = GLOB.is_sif, -- only use on my macbook
  event = 'InsertEnter',
  cmd = 'Copilot',
  build = ':Copilot auth',
  config = function()
    require('copilot').setup {
      suggestion = { enabled = true },
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
        sh = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
            -- disable for .env files
            return false
          end
          return true
        end,
        ['*'] = false, -- disable for all other filetypes and ignore default `filetypes`
      },
    }
  end,
}
