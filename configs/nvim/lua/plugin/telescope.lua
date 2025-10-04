return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "debugloop/telescope-undo.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    -- "2kabhishek/nerdy.nvim", -- search nerd icons
    -- { "nvim-telescope/telescope-fzf-native.nvim", enabled = vim.fn.executable "make" == 1, build = "make" },
  },
  event = "VeryLazy",
  keys = {
    { "<Leader>fa", "<CMD>Telescope find_files follow=true no_ignore=true hidden=true<CR>", desc = "Find all" },
    { "<Leader>fA", "<CMD>Telescope autocommands<CR>", desc = "[A]utocmd" },
    { "<Leader>f:", "<CMD>Telescope command_history<CR>", desc = "[C]ommand History" },
    { "<Leader>fc", "<CMD>Telescope commands<CR>", desc = "[C]ommands" },
    { "<Leader>ff", "<CMD>Telescope find_files<CR>", desc = "[F]iles" },
    { "<Leader>fF", "<CMD>Telescope filetypes<CR>", desc = "[F]iletypes" },
    { "<Leader>fg", "<CMD>Telescope live_grep<CR>", desc = "[G]rep" },
    { "<Leader>fb", "<CMD>Telescope buffers<CR>", desc = "[B]uffers" },
    { "<Leader>fh", "<CMD>Telescope help_tags<CR>", desc = "[H]elp" },
    { "<Leader>fH", "<CMD>Telescope highlights<CR>", desc = "[H]ighlights" },
    { "<Leader>fj", "<CMD>Telescope jumplist<CR>", desc = "[J]umplist" },
    { "<Leader>fk", "<CMD>Telescope keymaps<CR>", desc = "[K]eymaps" },
    { "<Leader>fl", "<CMD>Telescope loclist<CR>", desc = "[L]oclist" },
    { "<Leader>fo", "<CMD>Telescope oldfiles<CR>", desc = "[O]ldfiles" },
    { "<Leader>fq", "<CMD>Telescope quickfix<CR>", desc = "[Q]uickfix" },
    { "<Leader><Leader>", "<CMD>Telescope current_buffer_fuzzy_find<CR>", desc = "Grep This" },
    { "<Leader>fm", "<CMD>Telescope man_pages<CR>", desc = "[M]anpage" },
    { "<Leader>fM", "<CMD>Telescope marks<CR>", desc = "[M]arks" },
    { "<Leader>fu", "<CMD>Telescope undo<CR>", desc = "[U]ndo" },
    { "<Leader>fR", "<CMD>Telescope registers<CR>", desc = "[R]egisters" },
    { "<Leader>fr", "<CMD>Telescope resume<CR>", desc = "[R]esume" },
    { "<Leader>fv", "<CMD>Telescope vim_options<CR>", desc = "[V]im Options" },
    { "<Leader>fC", "<CMD>Telescope git_commits<CR>", desc = "Git [C]ommits" },
    { "<Leader>fs", "<CMD>Telescope git_status<CR>", desc = "Git [S]tatus" },
    { "<Leader>fS", "<CMD>Telescope git_stash<CR>", desc = "Git [S]tash" },
    { "<Leader>fB", "<CMD>Telescope git_branches<CR>", desc = "Git [B]ranches" },
    { "<Leader>fi", "<CMD>Nerdy<CR>", desc = "[I]cons" },
  },
  config = function()
    local actions = require "telescope.actions"
    local telescope = require "telescope"
    local icons = require("core.icons").telescope

    telescope.setup {
      defaults = {
        prompt_prefix = icons.Search .. "  ",
        selection_caret = icons.Selected .. " ",
        layout_strategy = "flex",
        borderchars = {
          prompt = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
          results = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
          preview = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
        },
        layout_config = {
          horizontal = {
            preview_width = 0.50,
          },
          vertical = {
            preview_height = 0.50,
          },
        },
        winblend = 0, -- set transparency (0 to 30 most useful)

        path_display = { "truncate" },
        vimgrep_arguments = {
          "rg",
          "-L",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--trim",
          "--hidden",
          "--glob",
          "!**/.git/*",
        },
        file_ignore_patterns = {
          "node_modules/",
          "%.git/",
          "%.DS_Store$",
          "target/",
          "build/",
          "%.o$",
        },
        mappings = {
          i = {
            ["<ESC>"] = actions.close,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
          },
          n = {
            ["q"] = actions.close,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        undo = {},
        ["ui-select"] = { require("telescope.themes").get_dropdown {} },
      },
    }
    -- telescope.load_extension "fzf"
    telescope.load_extension "undo"
    telescope.load_extension "ui-select"
    -- telescope.load_extension "nerdy"
  end,
}
