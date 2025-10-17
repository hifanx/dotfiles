-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ disable default keybinds                              │
-- ╰──────────────────────────────────────────────────────────╯
for _, bind in ipairs { 'grn', 'gra', 'gri', 'grr' } do
  pcall(vim.keymap.del, 'n', bind)
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ setup lsp attach                                      │
-- ╰──────────────────────────────────────────────────────────╯

-- Create augroups ONCE outside the callback
local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = true })
local detach_augroup = vim.api.nvim_create_augroup('lsp-detach', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end

    -- Buffer-local keymaps (won't duplicate)
    -- Buffer-local keymaps
    vim.keymap.set('n', 'gh', vim.diagnostic.open_float, { buffer = ev.buf, desc = '[G]oto [H]over Diagnostic' })
    vim.keymap.set({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, { buffer = ev.buf, desc = 'Code [A]ction' })
    vim.keymap.set('n', '<leader>lh', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = 'Signature [H]elp' })
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { buffer = ev.buf, desc = '[R]ename' })

    -- CodeLens support
    if client.supports_method(client, vim.lsp.protocol.Methods.textDocument_codeLens) then
      vim.keymap.set('n', '<leader>ll', vim.lsp.codelens.refresh, { buffer = ev.buf, desc = 'Code[L]ens refresh' })
      vim.keymap.set('n', '<leader>lL', vim.lsp.codelens.run, { buffer = ev.buf, desc = 'Code[L]ens run' })
    end

    -- Inlay hints
    if client.supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end

    -- Document highlight - buffer-specific autocmds
    if client.supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = ev.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = ev.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

vim.api.nvim_create_autocmd('LspDetach', {
  group = detach_augroup,
  callback = function(ev)
    vim.lsp.buf.clear_references()
    -- Clear only buffer-specific autocmds
    vim.api.nvim_clear_autocmds { group = highlight_augroup, buffer = ev.buf }
  end,
})

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ setup vim.diagnostic.Config                           │
-- ╰──────────────────────────────────────────────────────────╯
vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.HINT] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    header = '',
  },
}

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ server specific capabilities                          │
-- ╰──────────────────────────────────────────────────────────╯

local capabilities = vim.lsp.protocol.make_client_capabilities()

local has_blink = pcall(require, 'blink.cmp')
if has_blink then
  capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))
end

local has_markdown_oxide = vim.fn.executable 'markdown-oxide' == 1
if has_markdown_oxide then
  capabilities = vim.tbl_deep_extend('force', capabilities, {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  })
end

vim.lsp.config('*', {
  capabilities = capabilities,
})

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ this is where magic happens                           │
-- ╰──────────────────────────────────────────────────────────╯

local servers = {
  'cssls',
  'lua_ls',
  'bashls',
  'yamlls',
  'jsonls',
  'markdown_oxide',
  'taplo',
  'pyright',
  'docker_language_server',
}

vim.lsp.enable(servers)
