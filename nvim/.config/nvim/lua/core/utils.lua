local M = {}

--- Simplify the mapping of keys.
function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  mode = mode or "n"
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

--- Get the current hostname
-- @return string The system hostname in lowercase
local function get_hostname()
  local handle = io.popen "hostname 2>/dev/null"
  if handle then
    local result = handle:read "*l"
    handle:close()
    return result and result:lower() or "unknown"
  end
end

local function get_os() return vim.loop.os_uname().sysname:lower() end

function M.is_sif() return get_os() == "darwin" and get_hostname() == "sif.lan" end

return M
