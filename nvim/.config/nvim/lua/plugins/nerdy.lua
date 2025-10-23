return {
  '2kabhishek/nerdy.nvim',
  cmd = 'Nerdy',
  dependencies = {
    'nvim-mini/mini.pick',
  },
  config = function()
    require('nerdy').setup({
      max_recents = 30, -- Configure recent icons limit
      add_default_keybindings = false, -- Add default keybindings
      copy_to_clipboard = true, -- Copy glyph to clipboard instead of inserting
    })
  end,
}
