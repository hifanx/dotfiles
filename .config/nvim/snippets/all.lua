---@diagnostic disable: undefined-global

return {}, {
    s('(', fmt('({})', i(0))),
    s('[', fmt('[{}]', i(0))),
    s('{', fmta('{<>}', i(0))),
    s("'", fmt("'{}'", i(0))),
    s('"', fmt('"{}"', i(0))),
}
