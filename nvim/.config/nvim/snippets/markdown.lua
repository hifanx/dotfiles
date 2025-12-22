---@diagnostic disable: undefined-global

return {}, {
    s(
        '```',
        fmt(
            [[
                ```{}
                ```
            ]],
            { i(0, 'language') }
        )
    ),
}
