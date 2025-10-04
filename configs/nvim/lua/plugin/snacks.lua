---@diagnostic disable: undefined-global
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  dependencies = {
    { "folke/persistence.nvim", opts = {} },
  },
  keys = {
    { "<Leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    {
      "<Leader>,",
      function()
        Snacks.win {
          file = vim.fn.stdpath "config" .. "/tips.md",
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        }
      end,
      desc = "Tips and Tricks",
    },
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "[N]otification" },
    { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    { "D", function() Snacks.bufdelete() end, desc = "[D]elete Buffer" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "[G]oto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<Leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<Leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- Top Pickers & Explorer
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    -- find
    { "<leader>fh", function() Snacks.picker.help() end, desc = "[H]elp Pages" },
    { "<Leader>fH", function() Snacks.picker.highlights() end, desc = "[H]ighlights" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "[F]iles" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "[R]ecent" },
    { "<leader>f/", function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>fa", function() Snacks.picker.autocmds() end, desc = "[A]utocmds" },
    { "<leader>fc", function() Snacks.picker.command_history() end, desc = "[C]ommand History" },
    { "<leader>fC", function() Snacks.picker.commands() end, desc = "[C]ommands" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "[D]iagnostics" },
    { "<leader>fD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer [D]iagnostics" },
    { "<leader>fi", function() Snacks.picker.icons() end, desc = "[I]cons" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "[K]eymaps" },
    { "<leader>fl", function() Snacks.picker.loclist() end, desc = "[L]ocation List" },
    { "<leader>fm", function() Snacks.picker.marks() end, desc = "[M]arks" },
    { "<leader>fM", function() Snacks.picker.man() end, desc = "[M]an Pages" },
    { "<leader>fp", function() Snacks.picker.lazy() end, desc = "[P]lugin Spec" },
    { "<leader>fq", function() Snacks.picker.qflist() end, desc = "[Q]uickfix List" },
    { "<leader>fu", function() Snacks.picker.undo() end, desc = "[U]ndo History" },
    { "<leader><Space>", function() Snacks.picker.resume() end, desc = "[R]esume" },
    -- Grep
    { "<leader>fb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>fB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- git
    { "<Leader>gb", function() Snacks.git.blame_line() end, desc = "[G]it [B]lame Line" },
    { "<leader>gB", function() Snacks.picker.git_branches() end, desc = "[G]it [B]ranches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "[G]it [L]og" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "[G]it [L]og Line" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "[G]it [D]iff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "[G]it Log [F]ile" },
    { "<Leader>go", function() Snacks.gitbrowse() end, desc = "[O]pen in Browser", mode = { "n", "v" } },
    { "<Leader>gh", function() Snacks.lazygit.log_file() end, desc = "Lazy[g]it Current File [H]istory" },
    { "<Leader>gg", function() Snacks.lazygit() end, desc = "Lazy[g]it" },
    { "<Leader>gl", function() Snacks.lazygit.log() end, desc = "Lazy[g]it [L]og" },
  },
  opts = function()
    vim.api.nvim_create_autocmd("BufDelete", {
      group = vim.api.nvim_create_augroup("bufdelpost_autocmd", {}),
      desc = "BufDeletePost User autocmd",
      callback = function()
        vim.schedule(
          function()
            vim.api.nvim_exec_autocmds("User", {
              pattern = "BufDeletePost",
            })
          end
        )
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "BufDeletePost",
      group = vim.api.nvim_create_augroup("dashboard_delete_buffers", {}),
      desc = "Quit Neovim when no available buffers",
      callback = function(ev)
        local deleted_name = vim.api.nvim_buf_get_name(ev.buf)
        local deleted_ft = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
        local deleted_bt = vim.api.nvim_get_option_value("buftype", { buf = ev.buf })
        local no_buffers_left = deleted_name == "" and deleted_ft == "" and deleted_bt == ""
        if no_buffers_left then
          vim.cmd "quit" -- Quit Neovim when no buffers are left
        end
      end,
    })

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Lsp progress                                             │
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

    return {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = [[                                                                     
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
        },
      },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 5000, -- default: 3000
        top_down = false, -- false = down to top
        style = "minimal",
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      scope = { enabled = true },
      image = { enabled = false },
      explorer = { enabled = false },
      picker = { enabled = true },
    }
  end,
}
