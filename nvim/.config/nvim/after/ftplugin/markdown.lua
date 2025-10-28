-- ~/.config/nvim/after/ftplugin/markdown.lua

-- Custom fold expression that only folds ATX headings (# ## ###)
-- but ignores headings inside code blocks
local function markdown_heading_foldexpr()
  local lnum = vim.v.lnum
  local line = vim.fn.getline(lnum)

  -- Check for ATX-style headers (# ## ###)
  local header_match = line:match('^(#+)%s')
  if header_match then
    -- Use treesitter to check if we're in a code block
    local bufnr = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(bufnr, 'markdown')
    if parser then
      local tree = parser:parse()[1]
      if tree then
        local root = tree:root()
        -- Line numbers are 0-indexed in treesitter
        local node = root:named_descendant_for_range(lnum - 1, 0, lnum - 1, 0)

        -- Check if we're inside a fenced code block or inline code
        while node do
          local node_type = node:type()
          if node_type == 'fenced_code_block' or node_type == 'code_fence_content' then
            -- We're in a code block, don't fold
            return '='
          end
          node = node:parent()
        end

        -- Not in a code block, this is a real heading
        return '>' .. #header_match
      end
    end

    -- Fallback if treesitter not available
    return '>' .. #header_match
  end

  -- Check for Setext-style headers (underlined with = or -)
  local next_line = vim.fn.getline(lnum + 1)
  if next_line:match('^=+%s*$') and not line:match('^%s*$') then
    return '>1'
  elseif next_line:match('^-+%s*$') and not line:match('^%s*$') then
    return '>2'
  end

  return '='
end

-- Set up folding for markdown
vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = "v:lua.require'markdown_folds'.foldexpr()"
vim.opt_local.foldenable = true
vim.opt_local.foldlevelstart = 2
vim.opt_local.foldtext = ''

-- Create module to hold the fold function
if not package.loaded['markdown_folds'] then
  package.loaded['markdown_folds'] = {
    foldexpr = markdown_heading_foldexpr,
  }
end

-- Force recompute folds
vim.cmd('normal! zx')
