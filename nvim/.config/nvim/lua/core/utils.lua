local M = {}

--- Simplify the mapping of keys.
function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  mode = mode or 'n'
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Compute once using Neovim's native function
local hostname = vim.loop.os_gethostname():lower()
local os_name = vim.loop.os_uname().sysname:lower()

-- Store as simple boolean
M.is_sif = (os_name == 'darwin' and hostname == 'sif.lan')
M.is_macos = (os_name == 'darwin')
M.is_linux = (os_name == 'linux')
M.hostname = hostname

function M.start_treesitter(ev)
  local ok, err = pcall(vim.treesitter.start, ev.buf)
  if ok then
    vim.notify(string.format('Treesitter started for %s', ev.match), vim.log.levels.INFO, { title = 'Treesitter' })
  else
    vim.notify(
      string.format('Treesitter failed for %s: %s', ev.match, err),
      vim.log.levels.WARN,
      { title = 'Treesitter' }
    )
  end
end

return M
