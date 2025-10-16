---@diagnostic disable: undefined-global
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  dependencies = {
    { 'folke/persistence.nvim', opts = {} },
  },
  init = function()
    vim.keymap.set('n', '<Leader>.', function() Snacks.scratch() end, { desc = 'Scratch Buffer' })

    vim.keymap.set(
      'n',
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
      { desc = 'Vim Notes' }
    )

    vim.keymap.set('n', '<leader>n', function() Snacks.notifier.show_history() end, { desc = '[N]otification' })
    vim.keymap.set('n', '<c-/>', function() Snacks.terminal() end, { desc = 'Toggle Terminal' })
    vim.keymap.set('n', '<c-_>', function() Snacks.terminal() end, { desc = 'which_key_ignore' })
    vim.keymap.set({ 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end, { desc = 'Next Reference' })
    vim.keymap.set({ 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end, { desc = 'Prev Reference' })
    vim.keymap.set('n', '<C-x>', function() Snacks.bufdelete() end, { desc = '[D]elete Buffer' })

    -- LSP
    vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = '[G]oto [D]eclaration' })
    vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { nowait = true, desc = '[R]eferences' })
    vim.keymap.set('n', 'gI', function() Snacks.picker.lsp_implementations() end, { desc = '[G]oto [I]mplementation' })
    vim.keymap.set(
      'n',
      'gy',
      function() Snacks.picker.lsp_type_definitions() end,
      { desc = '[G]oto T[y]pe Definition' }
    )
    vim.keymap.set('n', '<Leader>ls', function() Snacks.picker.lsp_symbols() end, { desc = 'LSP [S]ymbols' })
    vim.keymap.set(
      'n',
      '<Leader>lS',
      function() Snacks.picker.lsp_workspace_symbols() end,
      { desc = 'LSP Workspace [S]ymbols' }
    )

    -- Top Pickers & Explorer
    vim.keymap.set('n', '<leader>e', function() Snacks.explorer() end, { desc = '[E]xplorer' })

    -- Find
    vim.keymap.set('n', '<leader>fh', function() Snacks.picker.help() end, { desc = '[H]elp Pages' })
    vim.keymap.set('n', '<Leader>fH', function() Snacks.picker.highlights() end, { desc = '[H]ighlights' })
    vim.keymap.set('n', '<leader>ff', function() Snacks.picker.files() end, { desc = '[F]iles' })
    vim.keymap.set('n', '<leader>fr', function() Snacks.picker.recent() end, { desc = '[R]ecent' })
    vim.keymap.set('n', '<leader>f/', function() Snacks.picker.search_history() end, { desc = 'Search History' })
    vim.keymap.set('n', '<leader>fa', function() Snacks.picker.autocmds() end, { desc = '[A]utocmds' })
    vim.keymap.set('n', '<leader>fc', function() Snacks.picker.command_history() end, { desc = '[C]ommand History' })
    vim.keymap.set('n', '<leader>fC', function() Snacks.picker.commands() end, { desc = '[C]ommands' })
    vim.keymap.set('n', '<leader>fd', function() Snacks.picker.diagnostics() end, { desc = '[D]iagnostics' })
    vim.keymap.set(
      'n',
      '<leader>fD',
      function() Snacks.picker.diagnostics_buffer() end,
      { desc = 'Buffer [D]iagnostics' }
    )
    vim.keymap.set('n', '<leader>fi', function() Snacks.picker.icons() end, { desc = '[I]cons' })
    vim.keymap.set('n', '<leader>fk', function() Snacks.picker.keymaps() end, { desc = '[K]eymaps' })
    vim.keymap.set('n', '<leader>fl', function() Snacks.picker.loclist() end, { desc = '[L]ocation List' })
    vim.keymap.set('n', '<leader>fm', function() Snacks.picker.marks() end, { desc = '[M]arks' })
    vim.keymap.set('n', '<leader>fM', function() Snacks.picker.man() end, { desc = '[M]an Pages' })
    vim.keymap.set('n', '<leader>fp', function() Snacks.picker.lazy() end, { desc = '[P]lugin Spec' })
    vim.keymap.set('n', '<leader>fq', function() Snacks.picker.qflist() end, { desc = '[Q]uickfix List' })
    vim.keymap.set('n', '<leader>fu', function() Snacks.picker.undo() end, { desc = '[U]ndo History' })
    vim.keymap.set('n', '<leader><Space>', function() Snacks.picker.resume() end, { desc = '[R]esume' })

    -- Grep
    vim.keymap.set('n', '<leader>fb', function() Snacks.picker.lines() end, { desc = '[B]uffer Lines' })
    vim.keymap.set('n', '<leader>fB', function() Snacks.picker.grep_buffers() end, { desc = 'Grep Open [B]uffers' })
    vim.keymap.set('n', '<leader>fg', function() Snacks.picker.grep() end, { desc = '[G]rep' })
    vim.keymap.set(
      { 'n', 'x' },
      '<leader>fw',
      function() Snacks.picker.grep_word() end,
      { desc = 'Visual selection or word' }
    )

    -- Git
    vim.keymap.set('n', '<Leader>gb', function() Snacks.git.blame_line() end, { desc = '[G]it [B]lame Line' })
    vim.keymap.set('n', '<leader>gB', function() Snacks.picker.git_branches() end, { desc = '[G]it [B]ranches' })
    vim.keymap.set('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = '[G]it [L]og' })
    vim.keymap.set('n', '<leader>gL', function() Snacks.picker.git_log_line() end, { desc = '[G]it [L]og Line' })
    vim.keymap.set('n', '<leader>gd', function() Snacks.picker.git_diff() end, { desc = '[G]it [D]iff (Hunks)' })
    vim.keymap.set('n', '<leader>gf', function() Snacks.picker.git_log_file() end, { desc = '[G]it Log [F]ile' })
    vim.keymap.set({ 'n', 'v' }, '<Leader>go', function() Snacks.gitbrowse() end, { desc = '[O]pen in Browser' })
    vim.keymap.set(
      'n',
      '<Leader>gh',
      function() Snacks.lazygit.log_file() end,
      { desc = 'Lazy[g]it Current File [H]istory' }
    )
    vim.keymap.set('n', '<Leader>gg', function() Snacks.lazygit() end, { desc = 'Lazy[g]it' })
    vim.keymap.set('n', '<Leader>gl', function() Snacks.lazygit.log() end, { desc = 'Lazy[g]it [L]og' })
  end,
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
