return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  lazy = false,
  init = function()
    -- NOTE: neovim 0.12 natively installed
    local already_have = {
      'c',
      'lua',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
    }
    local ensure_installed = {
      'bash',
      'diff',
      'dockerfile',
      'gitignore',
      'git_config',
      'luadoc',
      'regex',
      'toml',
      'yaml',
      'csv',
      'java',
      'python',
      'html',
      'css',
      'javascript',
      'typescript',
      'json',
    }

    -- Install missing parsers, then build a deduplicated list of filetypes to auto-enable treesitter
    local already_installed = require('nvim-treesitter.config').get_installed()
    local parsers_to_install = vim
      .iter(ensure_installed)
      :filter(function(parser) return not vim.tbl_contains(already_installed, parser) end)
      :totable()

    if #parsers_to_install > 0 then
      vim.defer_fn(function() require('nvim-treesitter').install(parsers_to_install) end, 1000)
    end
    require('nvim-treesitter').update()

    -- Build filetype pattern list (auto-deduplicates via set)
    local pattern_set = {}
    local function add_lang_filetypes(lang)
      local ok, fts = pcall(vim.treesitter.language.get_filetypes, lang)
      if ok and type(fts) == 'table' then
        for _, ft in ipairs(fts) do
          pattern_set[ft] = true
        end
      end
    end

    for _, lang in ipairs(already_have) do
      add_lang_filetypes(lang)
    end
    for _, lang in ipairs(ensure_installed) do
      add_lang_filetypes(lang)
    end

    local pattern = vim.tbl_keys(pattern_set)

    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Enable treesitter highlighting and indentation',
      group = vim.api.nvim_create_augroup('nvim_treesitter', { clear = true }),
      -- WARN: Do not use "*" here - snacks.nvim is buggy and vim.notify triggers FileType events internally causing infinite callback loops
      pattern = pattern,
      callback = function(ev) require('core.utils').start_treesitter(ev) end,
    })
  end,
  config = function() require('nvim-treesitter').setup() end,
}
