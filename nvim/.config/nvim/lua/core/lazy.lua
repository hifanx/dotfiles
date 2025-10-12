-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  spec = LAZY_PLUGIN_SPEC,
  defaults = { lazy = true, version = false }, -- always use the latest git commit
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      -- NOTE: see full list:
      -- https://github.com/neovim/neovim/tree/master/runtime/plugin
      disabled_plugins = {
        "tohtml.lua",
        "gzip.vim",
        "man.lua",
        "tarPlugin.vim",
        "zipPlugin.vim",
        "rplugin.vim",
      },
    },
  },
  rocks = {
    enabled = false,
    hererocks = false,
  },
}

require("core.utils").map("n", "<leader>hl", ":Lazy<CR>", { desc = "Lazy" })
