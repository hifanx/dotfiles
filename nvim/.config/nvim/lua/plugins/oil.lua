return {
  'stevearc/oil.nvim',
  lazy = false, -- need this or oil-ssh won't work properly
  dependencies = {
    'benomahony/oil-git.nvim',
  },
  init = function() vim.keymap.set('n', '<leader>o', ':Oil<CR>', { desc = '[O]il' }) end,
  config = function()
    require('oil').setup({
      default_file_explorer = true,
      delete_to_trash = true,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _) return name == '.git' end,
      },
      use_default_keymaps = true,
      -- See :help oil-actions for a list of all available actions
      -- NOTE: these are defaults.
      keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-l>'] = 'actions.refresh',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
      },
    })

    -- HACK: force yamlls to attach when oil-ssh into remote yaml files
    --  yamlls doesn't automatically attach because oil-ssh uses a custom URI scheme and can't find the root dir
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'yaml',
      callback = function(args)
        local bufnr = args.buf
        local uri = vim.uri_from_bufnr(bufnr)

        -- Check if this is an oil-ssh buffer
        if uri:match('^oil%-ssh://') then
          -- Manually start LSP for this buffer
          vim.lsp.start({
            name = 'yamlls',
            cmd = { 'yaml-language-server', '--stdio' },
            root_dir = vim.fn.getcwd(),
          }, {
            bufnr = bufnr,
          })
        end
      end,
    })
  end,
}
