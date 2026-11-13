---@diagnostic disable: undefined-global

-- {{{ bootstrap

local prefix = 'ctrl+a'
local function leader(key) return prefix .. '>' .. key end

-- }}}
-- {{{ actions

-- copy mode: open the focused pane's scrollback in nvim in a floating layer.
rex.action({
    name = 'copy_mode',
    title = 'Copy Mode (nvim)',
    run = function(ctx)
        if not ctx.block_id then error('no focused pane', 0) end
        local res, err = rex.call('session.new_layer', {
            session_id = ctx.session_id,
            bounds = { 0, 0, 1, 1 },
            layout = { block = { flavor = 'com.superlogical.terminal.shell' } },
            focus = true,
        })
        if not res then error(err, 0) end
        -- Leading space keeps it out of shell history (if hist_ignore_space is set).
        rex.block.call('com.superlogical.terminal', 'write', {
            block_id = res.block_ids[1],
            data = " rex capture -b '"
                .. ctx.block_id
                .. "' --trim --unwrap | nvim -R +'set clipboard=unnamedplus' +'normal G' -; exit\r",
        })
    end,
})

-- popups: 90% x 85% floating layer in the focused pane's cwd, like herdr's.
local function popup_cwd(ctx)
    local p = ctx.block_id
        and rex.block.call(
            'com.superlogical.terminal',
            'process',
            { block_id = ctx.block_id }
        )
    -- foreground cwd, not `pwd`: pwd is empty when the shell doesn't report OSC 7.
    return p and p.foreground and p.foreground.cwd or os.getenv('HOME')
end

local function popup(name, title, command)
    rex.action({
        name = name,
        title = title,
        run = function(ctx)
            local _, err = rex.session.new_layer({
                bounds = { 0.05, 0.075, 0.9, 0.85 },
                layout = rex.layout.block({
                    flavor = 'com.superlogical.terminal.shell',
                    options = { cwd = popup_cwd(ctx), command = command },
                }),
                focus = true,
            })
            if err ~= nil then error(err, 0) end
        end,
    })
end

popup('popup_lazygit', 'Popup: lazygit', { 'lazygit' })
popup('popup_yadm', 'Popup: yadm lazygit', { 'yadm', 'enter', 'lazygit' })
popup('popup_shell', 'Popup: terminal')
popup('popup_yazi', 'Popup: yazi', { 'yazi' })

-- cheatsheet: fzf over tldr custom pages; tldr renders pages/patches, bat the rest.
local tldr_pages = os.getenv('HOME') .. '/.config/tealdeer/pages'
popup('popup_cheat', 'Popup: cheatsheet', {
    'fzf',
    '--walker=file',
    '--walker-root=' .. tldr_pages,
    '--delimiter=/',
    '--with-nth=-1',
    '--preview=case {} in *.page.md|*.patch.md) tldr --color always -f {} ;; *.md) glow -s dark -w $FZF_PREVIEW_COLUMNS {} ;; *) bat --color=always --theme=isekai --style=grid,numbers --italic-text=always --terminal-width=$FZF_PREVIEW_COLUMNS {} ;; esac',
    '--preview-window=right,70%,wrap',
    '--bind=enter:become(nvim {})',
    '--bind=ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up',
})

-- toggle: hide popups one by one (they keep running) until none is visible,
-- then show them one by one until none is hidden, then hide again.
local popup_showing = false
rex.action({
    name = 'popup_toggle',
    title = 'Popup: toggle',
    run = function(ctx)
        local view, err =
            rex.call('session.view', { session_id = ctx.session_id })
        if not view then error(err, 0) end
        local hidden, visible, focused
        for _, win in ipairs(view.windows or {}) do
            if win.window_id == view.active_window_id then
                for _, layer in ipairs(win.layers or {}) do
                    if layer.kind == 'floating' then
                        if layer.state == 'minimized' then
                            hidden = layer.layer_id
                        else
                            visible = layer.layer_id
                            for _, b in ipairs(layer.blocks or {}) do
                                if b.block_id == ctx.block_id then
                                    focused = layer.layer_id
                                end
                            end
                        end
                    end
                end
            end
        end
        if not hidden then
            popup_showing = false
        elseif not visible then
            popup_showing = true
        end
        local target = popup_showing and hidden or focused or visible
        local state = popup_showing and 'normal' or 'minimized'
        if not target then return end
        local _, e = rex.call('session.set_layer_state', {
            session_id = ctx.session_id,
            layer_id = target,
            state = state,
            focus = state == 'normal' or nil,
        })
        if e ~= nil then error(e, 0) end
    end,
})

-- }}}

-- general
rex.bind(leader('ctrl+a'), 'pane.send_key', { key = 'ctrl+a' })
rex.bind(leader('shift+r'), 'client.config.reload')

-- session
rex.bind(leader('shift+s'), 'session.rename')
rex.bind(leader('s'), 'session.switch')

-- tab
rex.bind(leader('c'), 'client.tab.new')
rex.bind(leader('shift+t'), 'client.tab.rename')
for i = 1, 9 do
    rex.bind(leader(tostring(i)), 'client.tab.goto', { index = i })
end

-- pane
rex.bind(leader('h'), 'pane.focus.left')
rex.bind(leader('j'), 'pane.focus.down')
rex.bind(leader('k'), 'pane.focus.up')
rex.bind(leader('l'), 'pane.focus.right')
rex.bind(leader('shift+h'), 'pane.move.left')
rex.bind(leader('shift+j'), 'pane.move.down')
rex.bind(leader('shift+k'), 'pane.move.up')
rex.bind(leader('shift+l'), 'pane.move.right')
rex.bind(leader('\\'), 'pane.split', { direction = 'right' })
rex.bind(leader('shift+\\'), 'pane.split', { direction = 'left' })
rex.bind(leader('-'), 'pane.split', { direction = 'down' })
rex.bind(leader('shift+-'), 'pane.split', { direction = 'up' })
rex.bind(leader('shift+p'), 'pane.rename')
rex.bind(leader('x'), 'pane.close')
rex.bind(leader('z'), 'pane.zoom')

-- sticky: repeatable operations (resize, scroll)
rex.mode('sticky', { exclusive = true })
rex.bind(leader('r'), 'client.mode.enter', { name = 'sticky' })
rex.bind('sticky/=', 'pane.balance')
rex.bind('sticky/u', 'client.scroll.page_up')
rex.bind('sticky/d', 'client.scroll.page_down')
for key, dir in pairs({ h = 'left', j = 'down', k = 'up', l = 'right' }) do
    rex.bind('sticky/' .. key, 'pane.resize', { direction = dir, amount = 5 })
end

-- custom
rex.bind(leader('['), 'copy_mode')
rex.bind(leader('g'), 'popup_lazygit')
rex.bind(leader('shift+g'), 'popup_yadm')
rex.bind(leader('y'), 'popup_yazi')
rex.bind(leader('t'), 'popup_shell')
rex.bind(leader('shift+/'), 'popup_cheat')
rex.bind(leader('m'), 'popup_toggle')

-- vim: foldmethod=marker foldlevel=0
