local M = {}

--- Simplify the mapping of keys.
function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  mode = mode or "n"
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

--- Check if a lua plugin can be required without causing an error.
--- @param name string The plugin name to check for availability.
--- @return boolean `true` if the module can be loaded, `false` otherwise.
function M.is_available(name)
  local ok, _ = pcall(require, name)
  return ok
end

---Determine the operating system Neovim is running on.
---@return string
---| '"windows"' # When running on Windows systems (detected as 'windows_nt')
---| '"linux"'   # When running on Linux systems
---| '"macos"'   # When running on macOS (Darwin) systems
---| '"freebsd"' # When running on FreeBSD systems
---| '"openbsd"' # When running on OpenBSD systems
---| '"netbsd"'  # When running on NetBSD systems
---| 'string'    # The raw system name for other Unix-like systems
---@usage `local os_name = get_os()`
---@usage ```
---if get_os() == "windows" then
---  -- Windows-specific configuration
---  vim.opt.shell = "powershell"
---end
---```
---@example # Basic usage
---  print(get_os()) -- Outputs: "linux", "windows", "macos", etc.
function M.get_os()
  local uname = vim.loop.os_uname()
  local sysname = uname.sysname:lower()

  if sysname == "windows_nt" then
    return "windows"
  elseif sysname == "darwin" then
    return "macos"
  elseif sysname == "linux" then
    return "linux"
  else
    return sysname
  end
end

function M.is_mac() return M.get_os() == "macos" end

return M
