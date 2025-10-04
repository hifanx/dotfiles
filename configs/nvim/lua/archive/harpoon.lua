return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = function()
    local harpoon = require "harpoon"
    return {
      { "<Leader>ha", function() harpoon:list():add() end, desc = "Harpoon add file" },
      { "<Leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Toggle harpoon menu" },
      { "<C-p>", function() harpoon:list():prev() end, desc = "Goto previous mark" },
      { "<C-n>", function() harpoon:list():next() end, desc = "Goto next mark" },
    }
  end,
  opts = {},
}
