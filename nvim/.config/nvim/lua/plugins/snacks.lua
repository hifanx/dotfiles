---@diagnostic disable: undefined-global
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  dependencies = {
    { 'folke/persistence.nvim', opts = {} },
  },
  keys = {
    { '<Leader>.', function() Snacks.scratch() end, desc = 'Scratch Buffer' },
    {
      '<Leader>,',
      function()
        Snacks.win {
          file = vim.fn.stdpath 'config' .. '/tips.md',
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = 'yes',
            statuscolumn = ' ',
            conceallevel = 3,
          },
        }
      end,
      desc = 'Vim Notes',
    },
    { '<leader>n', function() Snacks.notifier.show_history() end, desc = '[N]otification' },
    { '<c-/>', function() Snacks.terminal() end, desc = 'Toggle Terminal' },
    { '<c-_>', function() Snacks.terminal() end, desc = 'which_key_ignore' },
    { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' } },
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },
    { '<C-x>', function() Snacks.bufdelete() end, desc = '[D]elete Buffer' },
    -- LSP
    { 'gd', function() Snacks.picker.lsp_definitions() end, desc = '[G]oto [D]efinition' },
    { 'gD', function() Snacks.picker.lsp_declarations() end, desc = '[G]oto [D]eclaration' },
    { 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = '[R]eferences' },
    { 'gI', function() Snacks.picker.lsp_implementations() end, desc = '[G]oto [I]mplementation' },
    { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = '[G]oto T[y]pe Definition' },
    { '<Leader>ls', function() Snacks.picker.lsp_symbols() end, desc = 'LSP [S]ymbols' },
    { '<Leader>lS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace [S]ymbols' },
    -- Top Pickers & Explorer
    { '<leader>e', function() Snacks.explorer() end, desc = '[E]xplorer' },
    -- find
    { '<leader>fh', function() Snacks.picker.help() end, desc = '[H]elp Pages' },
    { '<Leader>fH', function() Snacks.picker.highlights() end, desc = '[H]ighlights' },
    { '<leader>ff', function() Snacks.picker.files() end, desc = '[F]iles' },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = '[R]ecent' },
    { '<leader>f/', function() Snacks.picker.search_history() end, desc = 'Search History' },
    { '<leader>fa', function() Snacks.picker.autocmds() end, desc = '[A]utocmds' },
    { '<leader>fc', function() Snacks.picker.command_history() end, desc = '[C]ommand History' },
    { '<leader>fC', function() Snacks.picker.commands() end, desc = '[C]ommands' },
    { '<leader>fd', function() Snacks.picker.diagnostics() end, desc = '[D]iagnostics' },
    { '<leader>fD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer [D]iagnostics' },
    { '<leader>fi', function() Snacks.picker.icons() end, desc = '[I]cons' },
    { '<leader>fk', function() Snacks.picker.keymaps() end, desc = '[K]eymaps' },
    { '<leader>fl', function() Snacks.picker.loclist() end, desc = '[L]ocation List' },
    { '<leader>fm', function() Snacks.picker.marks() end, desc = '[M]arks' },
    { '<leader>fM', function() Snacks.picker.man() end, desc = '[M]an Pages' },
    { '<leader>fp', function() Snacks.picker.lazy() end, desc = '[P]lugin Spec' },
    { '<leader>fq', function() Snacks.picker.qflist() end, desc = '[Q]uickfix List' },
    { '<leader>fu', function() Snacks.picker.undo() end, desc = '[U]ndo History' },
    { '<leader><Space>', function() Snacks.picker.resume() end, desc = '[R]esume' },
    -- Grep
    { '<leader>fb', function() Snacks.picker.lines() end, desc = '[B]uffer Lines' },
    { '<leader>fB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open [B]uffers' },
    { '<leader>fg', function() Snacks.picker.grep() end, desc = '[G]rep' },
    { '<leader>fw', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' } },
    -- git
    -- { '<Leader>gb', function() Snacks.git.blame_line() end, desc = '[G]it [B]lame Line' },
    -- { '<leader>gB', function() Snacks.picker.git_branches() end, desc = '[G]it [B]ranches' },
    { '<leader>gl', function() Snacks.picker.git_log() end, desc = '[G]it [L]og' },
    { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = '[G]it [L]og Line' },
    { '<leader>gd', function() Snacks.picker.git_diff() end, desc = '[G]it [D]iff (Hunks)' },
    { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = '[G]it Log [F]ile' },
    { '<Leader>go', function() Snacks.gitbrowse() end, desc = '[O]pen in Browser', mode = { 'n', 'v' } },
    { '<Leader>gh', function() Snacks.lazygit.log_file() end, desc = 'Lazy[g]it Current File [H]istory' },
    { '<Leader>gg', function() Snacks.lazygit() end, desc = 'Lazy[g]it' },
    { '<Leader>gl', function() Snacks.lazygit.log() end, desc = 'Lazy[g]it [L]og' },
  },
  config = function()
    require('snacks').setup {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
            { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
            { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
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
        margin = { top = 1, right = 1, bottom = 2 },
        timeout = 5000, -- default: 3000
        top_down = false, -- false = down to top
        style = 'minimal',
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      scope = { enabled = true },
      image = { enabled = false },
      explorer = { enabled = true },
      picker = {
        enabled = true,
        layout = { preset = 'bottom' },
        win = {
          input = {
            keys = {
              -- close the picker on ESC instead of going to normal mode,
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
              ['<c-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
              ['<c-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
            },
          },
        },
      },
      lazygit = {
        enabled = true,
        theme = {
          inactiveBorderColor = { fg = 'NonText' },
        },
      },
      styles = {
        scratch = {
          wo = {
            winhighlight = 'Normal:NormalFloat',
          },
        },
        input = {
          row = 3,
        },
      },
    }
  end,
}
