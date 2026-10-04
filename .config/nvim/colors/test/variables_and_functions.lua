local M = {}
local vim = vim

local PI = 3.14
local MAX_RETRY = 3
local LOG_LEVEL_ERROR = 'error'

print(LOG_LEVEL_ERROR)

local nothing = vim.NIL
print(nothing)

---@attribute custom
---@attribute builtin

---@class User this is a user
---@field name string this is a string
---@field age  number this is a number
---@return string social_security is a return value
local UserType = {}

---@class AsyncResult
local AsyncResult = {}

local list_of_numbers ---@type number[]

local function compute_sum(a, b, _)
    local result = a + b
    local self = {
        total = result,
        meta = { retries = 0 },
    }
    return self
end

local function run_with_retry(fn, max_retry)
    max_retry = max_retry or MAX_RETRY

    local attempt = 0
    while attempt < max_retry do
        attempt = attempt + 1

        local ok, res = pcall(fn)
        if ok then
            return res
        else
            vim.schedule(function() vim.notify('retry #' .. attempt, vim.log.levels.WARN) end)
        end
    end

    error('too many retries')
end

local function use_coroutine()
    local co = coroutine.create(function() coroutine.yield(42) end)
    local ok, value = coroutine.resume(co)
    return ok and value or nil
end

local function debug_example(x)
    if x == nil then
        vim.notify('debug: nil', vim.log.levels.DEBUG)
    else
        assert(type(x) == 'number', 'expected number')
    end
end

print(M)

return {
    compute_sum = compute_sum,
    run_with_retry = run_with_retry,
    use_coroutine = use_coroutine,
    debug_example = debug_example,
    PI = PI,
    MAX_RETRY = MAX_RETRY,
    UserType = UserType,
    AsyncResult = AsyncResult,
    list_of_numbers = list_of_numbers,
}
