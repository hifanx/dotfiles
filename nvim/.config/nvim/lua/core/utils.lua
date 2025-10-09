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

function M.is_mac() return M.get_os() == "macos" end

return M
