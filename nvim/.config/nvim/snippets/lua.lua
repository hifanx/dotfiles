---@diagnostic disable: undefined-global

return {
    -- local
    s('l', fmt([[ local {} ]], { i(0) })),
    s('ll', fmt([[ local {} = {} ]], { i(1), i(0) })),
    s(
        'lm',
        fmta(
            [[
                local M = {}
                    <>
                return M
            ]],
            { i(0) }
        )
    ),
    s(
        'lf',
        fmt(
            [[
                local function {}({})
                    {}
                end
            ]],
            { i(1), i(2), i(0) }
        )
    ),
    s(
        'lff',
        fmt(
            [[
                local {} = function({})
                    {}
                end
            ]],
            { i(1), i(2), i(0) }
        )
    ),
    -- if
    s(
        'if',
        fmt(
            [[
                if {} then
                    {}
                end
            ]],
            { i(1), i(0) }
        )
    ),
    s(
        'eif',
        fmt(
            [[
                elseif {} then
                    {}
            ]],
            { i(1), i(0) }
        )
    ),
    -- for && while
    s(
        'for',
        fmt(
            [[
                for {} do
                    {}
                end
            ]],
            { i(1), i(0) }
        )
    ),
    s(
        'forn',
        fmt(
            [[
                for {} = {}, {} do
                    {}
                end
            ]],
            { i(1, 'i'), i(2, '1'), i(3, '10'), i(0) }
        )
    ),
    s(
        'fori',
        fmt(
            [[
                for {}, {} in ipairs({}) do
                    {}
                end
            ]],
            { i(1), i(2), i(3), i(0) }
        )
    ),
    s(
        'w',
        fmt(
            [[
                while {} do
                    {}
                end
            ]],
            { i(1), i(0) }
        )
    ),
    -- function
    s(
        'f',
        fmt(
            [[
                function()
                    {}
                end
            ]],
            { i(0) }
        )
    ),
    s(
        'fm',
        fmt(
            [[
                function M.{}({})
                    {}
                end
            ]],
            { i(1), i(2), i(0) }
        )
    ),
    -- print
    s('p', fmt([[ print({}) ]], { i(0) })),
    s('pi', fmt([[ print(vim.inspect({})) ]], { i(0) })),
}
