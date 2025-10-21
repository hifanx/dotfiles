---@diagnostic disable: undefined-global
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  init = function()
    vim.keymap.set('n', '<leader>.', function() Snacks.scratch() end, { desc = 'Scratch Buffer' })
    vim.keymap.set(
      'n',
      '<leader>n',
      function()
        Snacks.win({
          file = vim.fn.stdpath('config') .. '/tips.md',
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = 'yes',
            statuscolumn = ' ',
            conceallevel = 3,
          },
        })
      end,
      { desc = 'Vim [N]otes' }
    )
    vim.keymap.set('n', '<c-/>', function() Snacks.terminal() end, { desc = 'Terminal' })
    vim.keymap.set({ 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end, { desc = 'Next reference' })
    vim.keymap.set({ 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end, { desc = 'Prev reference' })
    vim.keymap.set('n', '<C-x>', function() Snacks.bufdelete() end, { desc = 'Delete buffer' })

    -- LSP
    vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'LSP [D]efinition' })
    vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'LSP [D]eclaration' })
    vim.keymap.set(
      'n',
      'gr',
      function() Snacks.picker.lsp_references() end,
      { nowait = true, desc = 'LSP [R]eferences' }
    )
    vim.keymap.set('n', 'gI', function() Snacks.picker.lsp_implementations() end, { desc = 'LSP [I]mplementation' })
    vim.keymap.set('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = 'LSP T[y]pe Definition' })
    vim.keymap.set('n', '<leader>ls', function() Snacks.picker.lsp_symbols() end, { desc = 'Document [S]ymbols' })
    vim.keymap.set(
      'n',
      '<leader>lS',
      function() Snacks.picker.lsp_workspace_symbols() end,
      { desc = 'Workspace [S]ymbols' }
    )

    -- Top Pickers & Explorer
    vim.keymap.set('n', '<leader>e', function() Snacks.explorer() end, { desc = '[E]xplorer' })

    -- Find
    vim.keymap.set('n', '<leader>fh', function() Snacks.picker.help() end, { desc = '[H]elp pages' })
    vim.keymap.set('n', '<leader>fH', function() Snacks.picker.highlights() end, { desc = '[H]ighlights' })
    vim.keymap.set('n', '<leader>ff', function() Snacks.picker.files() end, { desc = '[F]iles' })
    vim.keymap.set('n', '<leader>fr', function() Snacks.picker.recent() end, { desc = '[R]ecent' })
    vim.keymap.set('n', '<leader>fa', function() Snacks.picker.autocmds() end, { desc = '[A]utocmds' })
    vim.keymap.set('n', '<leader>fC', function() Snacks.picker.command_history() end, { desc = '[C]ommand history' })
    vim.keymap.set('n', '<leader>fc', function() Snacks.picker.commands() end, { desc = '[C]ommands' })
    vim.keymap.set('n', '<leader>fD', function() Snacks.picker.diagnostics() end, { desc = 'Workspace [D]iagnostics' })
    vim.keymap.set(
      'n',
      '<leader>fd',
      function() Snacks.picker.diagnostics_buffer() end,
      { desc = 'Buffer [D]iagnostics' }
    )
    vim.keymap.set('n', '<leader>fi', function() Snacks.picker.icons() end, { desc = '[I]cons' })
    vim.keymap.set('n', '<leader>fk', function() Snacks.picker.keymaps() end, { desc = '[K]eymaps' })
    vim.keymap.set('n', '<leader>fl', function() Snacks.picker.loclist() end, { desc = '[L]ocation list' })
    vim.keymap.set('n', '<leader>fm', function() Snacks.picker.marks() end, { desc = '[M]arks' })
    vim.keymap.set('n', '<leader>fM', function() Snacks.picker.man() end, { desc = '[M]an pages' })
    vim.keymap.set('n', '<leader>fp', function() Snacks.picker.lazy() end, { desc = '[P]lugin spec' })
    vim.keymap.set('n', '<leader>fq', function() Snacks.picker.qflist() end, { desc = '[Q]uickfix list' })
    vim.keymap.set('n', '<leader>fu', function() Snacks.picker.undo() end, { desc = '[U]ndo history' })
    vim.keymap.set('n', '<leader><space>', function() Snacks.picker.resume() end, { desc = '[R]esume' })

    -- Grep
    vim.keymap.set('n', '<leader>fb', function() Snacks.picker.lines() end, { desc = '[B]uffer' })
    vim.keymap.set('n', '<leader>fB', function() Snacks.picker.grep_buffers() end, { desc = '[B]uffers opened' })
    vim.keymap.set('n', '<leader>fg', function() Snacks.picker.grep() end, { desc = '[G]rep' })
    vim.keymap.set(
      { 'n', 'x' },
      '<leader>fw',
      function() Snacks.picker.grep_word() end,
      { desc = '[Word] under cursor' }
    )

    -- Git
    vim.keymap.set({ 'n', 'v' }, '<leader>go', function() Snacks.gitbrowse() end, { desc = '[O]pen in browser' })
    vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end, { desc = 'Lazy[g]it' })
  end,
  config = function()
    require('snacks').setup({
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            {
              icon = ' ',
              key = 'f',
              desc = 'Find File',
              action = ":lua Snacks.dashboard.pick('files')",
            },
            {
              icon = ' ',
              key = 'g',
              desc = 'Find Text',
              action = ":lua Snacks.dashboard.pick('live_grep')",
            },
            {
              icon = ' ',
              key = 's',
              desc = 'Restore Session',
              section = 'session',
            },
            {
              icon = '󰒲 ',
              key = 'l',
              desc = 'Lazy',
              action = ':Lazy',
              enabled = package.loaded.lazy ~= nil,
            },
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
      indent = {
        enabled = true,
        animate = {
          duration = {
            step = 20, -- ms per step
            total = 200, -- maximum duration
          },
        },
        indent = {
          char = '',
          only_scope = true, -- only show indent guides of the scope
          only_current = true, -- only show indent guides in the current window
        },
        scope = {
          char = '',
          only_current = true, -- only show scope in the current window
        },
      },
      input = { enabled = true },
      notifier = { enabled = false },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      scope = { enabled = true },
      image = { enabled = false },
      explorer = {
        enabled = true,
        replace_netrw = true,
      },
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
          minimal = true,
          wo = {
            winhighlight = 'Normal:NormalFloat',
          },
        },
      },
    })
  end,
}
