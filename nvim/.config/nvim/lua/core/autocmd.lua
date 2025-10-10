vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function() vim.hl.on_yank { higroup = "IncSearch", timeout = 300 } end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Set highlights after colorscheme loaded",
  callback = function()
    require "core.highlights"
    vim.notify("Colorscheme loaded and highlights set", vim.log.levels.INFO, { title = "Neovim" })
  end,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  desc = "Show lsp line diagnostics automatically in hover window",
  group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
  callback = function() vim.diagnostic.open_float(nil, { focus = false }) end,
})

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ Lsp progress                                          │
-- ╰──────────────────────────────────────────────────────────╯
-- https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md#-examples
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then return end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v) return table.insert(msg, v.msg) or not v.done end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          ---@diagnostic disable-next-line: undefined-field
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})
