if not vim.g.is_sif then return end

vim.keymap.set(
    { 'n', 'x' },
    '<Leader>oo',
    function() require('opencode').ask('@this: ') end,
    { desc = 'Ask OpenCode…' }
)
vim.keymap.set({ 'n', 'x' }, '<Leader>os', function() require('opencode').select() end, { desc = 'Select OpenCode…' })
vim.keymap.set(
    'n',
    '<Leader>on',
    function() require('opencode').command('session.new') end,
    { desc = 'New OpenCode session' }
)
vim.keymap.set(
    'n',
    '<Leader>oi',
    function() require('opencode').command('session.interrupt') end,
    { desc = 'Interrupt OpenCode' }
)
vim.keymap.set(
    { 'n', 'x' },
    'go',
    function() return require('opencode').operator('@this ') end,
    { desc = 'Append range to OpenCode', expr = true }
)
vim.keymap.set(
    { 'n' },
    'goo',
    function() return require('opencode').operator('@this ') .. '_' end,
    { desc = 'Append line to OpenCode', expr = true }
)
