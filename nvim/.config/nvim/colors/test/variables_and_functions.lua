-- module + module.builtin
local M = {} -- M: @module
local vim = vim -- vim: @module.builtin (builtin namespace)

-- constant identifiers
local PI = 3.14 -- PI: @constant
local MAX_RETRY = 3 -- MAX_RETRY: @constant
local LOG_LEVEL_ERROR = 'error' -- LOG_LEVEL_ERROR: @constant.macro (macro-like)
print(LOG_LEVEL_ERROR)

-- built-in constants
local nothing = vim.NIL -- vim.NIL: @constant.builtin
print(nothing)

-- attribute-like annotations (Lua doesn't have real attributes but TS often
-- highlights special comments as @attribute / @attribute.builtin)
---@attribute custom       -- @attribute
---@attribute builtin      -- @attribute.builtin

-- simple user type / alias
---@class User ---@type.definition
---@field name string
---@field age  number
local UserType = {} -- UserType: @type

---@class AsyncResult ---@type.definition
local AsyncResult = {} -- AsyncResult: @type

-- builtin-like type name (simulated)
local list_of_numbers ---@type number[] -- number: @type.builtin

-- variable / parameter / member / property
local function compute_sum(a, b, _)
    -- a, b: @variable.parameter
    -- _: @variable.parameter.builtin (special placeholder parameter)
    local result = a + b -- result: @variable, `+`: @operator
    local self = { -- self: @variable.builtin
        total = result, -- total: @variable.member / @property
        meta = { retries = 0 }, -- retries: @property
    }
    return self -- return: @keyword.return
end

-- keyword.function, keyword.modifier, keyword.repeat, keyword.conditional
local function run_with_retry(fn, max_retry)
    -- fn, max_retry: @variable.parameter
    max_retry = max_retry or MAX_RETRY -- `or`: @keyword.operator

    local attempt = 0 -- attempt: @variable
    while attempt < max_retry do -- while: @keyword.repeat, `<`: @operator
        attempt = attempt + 1 -- `+`: @operator

        local ok, res = pcall(fn) -- pcall: @function.builtin, fn(): @function.call
        if ok then -- if: @keyword.conditional
            return res
        else
            vim.schedule(function() -- vim.schedule: @function.method.call
                vim.notify('retry #' .. attempt, vim.log.levels.WARN)
            end)
        end
    end

    error('too many retries') -- error: @keyword.exception / @function.builtin
end

-- coroutine style keywords (@keyword.coroutine simulated with comment)
-- NOTE: Lua has `coroutine.create` etc., but some grammars mark these
-- calls/identifiers as coroutine-related keywords.
local function use_coroutine()
    local co = coroutine.create(function() -- coroutine.create: @function.builtin, `function`: @keyword.function
        coroutine.yield(42) -- coroutine.yield: @function.builtin, `yield`: @keyword.coroutine
    end)
    local ok, value = coroutine.resume(co) -- resume: @function.builtin
    return ok and value or nil -- `and`, `or`: @keyword.operator
end

-- debug related keyword / exception simulation
local function debug_example(x)
    if x == nil then -- `==`: @operator
        vim.notify('debug: nil', vim.log.levels.DEBUG) -- DEBUG: @keyword.debug (via TS query)
    else
        assert(type(x) == 'number', 'expected number') -- assert: @function.builtin, error path: @keyword.exception
    end
end

-- import / type keywords (LuaSimulated)
-- In other languages this would look like:
-- import os
-- `import`: @keyword.import, os: @module.builtin from math import sqrt as root
-- `from`, `import`: @keyword.import

print(M)

return {
    compute_sum = compute_sum, -- property + function reference
    run_with_retry = run_with_retry,
    use_coroutine = use_coroutine,
    debug_example = debug_example,
    PI = PI,
    MAX_RETRY = MAX_RETRY,
    UserType = UserType,
    AsyncResult = AsyncResult,
    list_of_numbers = list_of_numbers,
}
