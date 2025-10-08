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

function M.on_attach(client)
  local map = M.map
  map("n", "gh", vim.diagnostic.open_float, { desc = "[G]oto [H]over Diagnostic" })
  map({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, { desc = "Code [A]ction" })
  -- map("n", "gd", "<CMD>Telescope lsp_definitions<CR>", { desc = "[G]oto [D]efinition" })
  -- map("n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" })
  -- map("n", "gi", "<CMD>Telescope lsp_implementations<CR>", { desc = "[G]oto [I]mplementation" })
  -- map("n", "gr", "<CMD>Telescope lsp_references<CR>", { desc = "[G]oto [R]eferences" })
  map("n", "<Leader>lh", vim.lsp.buf.signature_help, { desc = "Signature [H]elp" })
  -- map("n", "gy", "<CMD>Telescope lsp_type_definitions<CR>", { desc = "T[y]pe Definition" })
  -- map("n", "<leader>ls", "<CMD>Telescope lsp_document_symbols<CR>", { desc = "Document [S]ymbols" })
  -- map("n", "<leader>lS", "<CMD>Telescope lsp_workspace_symbols<CR>", { desc = "Workspace [S]ymbols" })
  -- map("n", "<leader>ld", "<CMD>Telescope diagnostics<CR>", { desc = "[D]iagnostics " })
  if client.supports_method "textDocument/codeLens" then
    map("n", "<Leader>ll", vim.lsp.codelens.refresh, { desc = "Code[L]ens refresh" })
    map("n", "<Leader>lL", vim.lsp.codelens.run, { desc = "Code[L]ens run" })
  end
  if client.supports_method "textDocument/rename" then
    map("n", "<Leader>lr", vim.lsp.buf.rename, { desc = "[R]ename" })
  end
  -- enable inlay hints
  if client.supports_method "textDocument/inlayHint" then
    vim.g.inlay_hints_visible = true
    vim.lsp.inlay_hint.enable(true)
    vim.notify(client.name .. " supports inlay hints", vim.log.levels.INFO)
  end
end

return M
