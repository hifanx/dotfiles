vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function() vim.hl.on_yank { higroup = 'IncSearch', timeout = 300 } end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Set highlights after colorscheme loaded',
  callback = function()
    require 'core.highlights'
    vim.notify('Colorscheme loaded and highlights set', vim.log.levels.INFO, { title = 'Neovim' })
  end,
})

vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  desc = 'Show lsp line diagnostics automatically in hover window',
  group = vim.api.nvim_create_augroup('float_diagnostic', { clear = true }),
  callback = function() vim.diagnostic.open_float(nil, { focus = false }) end,
})
