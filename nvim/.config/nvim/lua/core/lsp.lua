-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ Disable default keybinds                              │
-- ╰──────────────────────────────────────────────────────────╯
for _, bind in ipairs { "grn", "gra", "gri", "grr" } do
  pcall(vim.keymap.del, "n", bind)
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ Setup keymaps                                         │
-- ╰──────────────────────────────────────────────────────────╯
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
  callback = function(event)
    local m = require("core.utils").map
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then return end

    m("n", "gh", vim.diagnostic.open_float, { desc = "[G]oto [H]over Diagnostic" })
    m({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, { desc = "Code [A]ction" })
    m("n", "<Leader>lh", vim.lsp.buf.signature_help, { desc = "Signature [H]elp" })
    m("n", "<leader>li", ":LspInfo<CR>", { desc = "LSP [I]nfo" })
    m("n", "<Leader>lr", vim.lsp.buf.rename, { desc = "[R]ename" })

    if client.supports_method(client, vim.lsp.protocol.Methods.textDocument_codeLens) then
      m("n", "<Leader>ll", vim.lsp.codelens.refresh, { desc = "Code[L]ens refresh" })
      m("n", "<Leader>lL", vim.lsp.codelens.run, { desc = "Code[L]ens run" })
    end

    if client.supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.g.inlay_hints_visible = true
      vim.lsp.inlay_hint.enable(true)
      vim.notify(client.name .. " supports inlay hints", vim.log.levels.INFO)
    end
  end,
})

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ Setup vim.diagnostic.Config                           │
-- ╰──────────────────────────────────────────────────────────╯
vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  virtual_text = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    source = true,
    header = "",
  },
}

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ Setup capabilities                                    │
-- ╰──────────────────────────────────────────────────────────╯

local capabilities = vim.lsp.protocol.make_client_capabilities()
local is_available = require("core.utils").is_available

local has_blink = is_available "blink.cmp"
if has_blink then
  capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))
end

local has_markdown_oxide = vim.fn.executable "markdown-oxide" == 1
if has_markdown_oxide then
  capabilities = vim.tbl_deep_extend("force", capabilities, {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  })
end

vim.lsp.config("*", {
  capabilities = capabilities,
})

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ This is where magic happens                           │
-- ╰──────────────────────────────────────────────────────────╯

local servers = {
  "cssls",
  "lua_ls",
  "bashls",
  "yamlls",
  "jsonls",
  "markdown_oxide",
  "taplo",
  "pyright",
  "docker_language_server",
}

vim.lsp.enable(servers)
