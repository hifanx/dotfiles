-- Persistent scratch files toggled in one shared float
local dir = vim.fn.stdpath('config')
local win

-- Opaque base bg for scratch.md so markdown code blocks render against it
local c = require('palette').isekai
local md_ns = vim.api.nvim_create_namespace('scratch_md')
vim.api.nvim_set_hl(md_ns, 'NormalFloat', { fg = c.text, bg = c.base })
vim.api.nvim_set_hl(md_ns, 'FloatBorder', { fg = c.border, bg = c.base })

local function save(buf)
    if vim.api.nvim_buf_is_loaded(buf) then
        vim.api.nvim_buf_call(buf, function() vim.cmd('silent! update') end)
    end
end

-- Run the buffer (or visual selection) as Lua, printing any return values to :messages
local function run()
    local s, e = 1, -1
    if vim.fn.mode() ~= 'n' then
        s, e = vim.fn.line('v'), vim.fn.line('.')
        if s > e then
            s, e = e, s
        end
    end
    local fn = assert(
        load(
            table.concat(vim.api.nvim_buf_get_lines(0, s - 1, e, false), '\n'),
            '=scratch'
        )
    )
    local res = vim.F.pack_len(fn())
    if res.n > 0 then vim.print(vim.F.unpack_len(res)) end
end

local function toggle(name)
    local buf = vim.fn.bufadd(dir .. '/' .. name)
    if name:match('%.lua$') then
        vim.keymap.set(
            { 'n', 'x' },
            '<CR>',
            run,
            { buffer = buf, desc = 'Run scratch' }
        )
    end
    local footer = { { ' ' .. name .. ' ', 'Comment' } }
    local ns = name:match('%.md$') and md_ns or 0
    if win and vim.api.nvim_win_is_valid(win) then
        local shown = vim.api.nvim_win_get_buf(win)
        if shown == buf then return vim.api.nvim_win_close(win, false) end -- WinClosed saves
        save(shown)
        vim.api.nvim_win_set_config(win, { footer = footer })
        vim.api.nvim_win_set_buf(win, buf)
        vim.api.nvim_win_set_hl_ns(win, ns)
        return
    end
    local width = math.floor(vim.o.columns * 0.6)
    local height = math.floor((vim.o.lines - vim.o.cmdheight) * 0.9)
    win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = math.floor((vim.o.lines - vim.o.cmdheight - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        footer = footer,
        footer_pos = 'center',
    })
    vim.api.nvim_win_set_hl_ns(win, ns)
    local opened = win
    vim.api.nvim_create_autocmd('WinClosed', {
        pattern = tostring(opened),
        once = true,
        callback = function() save(vim.api.nvim_win_get_buf(opened)) end,
    })
end

vim.keymap.set(
    'n',
    '<leader>,',
    function() toggle('scratch.lua') end,
    { desc = 'Scratch buffer' }
)
vim.keymap.set(
    'n',
    '<leader>.',
    function() toggle('scratch.md') end,
    { desc = 'Scratch note' }
)
