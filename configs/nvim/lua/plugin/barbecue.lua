return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    -- better performance when moving the cursor around
    -- see https://github.com/utilyre/barbecue.nvim?tab=readme-ov-file#-recipes
    vim.api.nvim_create_autocmd({
      "WinResized", --[[ "WinScrolled", ]] -- or WinResized on NVIM-v0.9 and higher
      "BufWinEnter",
      "CursorHold",
      "InsertLeave",
    }, {
      group = vim.api.nvim_create_augroup("barbecue.updater", {}),
      callback = function() require("barbecue.ui").update() end,
    })

    return {
      create_autocmd = false, -- prevent barbecue from updating itself automatically
    }
  end,
}
