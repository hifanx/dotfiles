local m = require("core.utils").map

-- basic
m("n", "<C-s>", ":w<CR>", { desc = "[W]rite" })
m("n", "<C-q>", ":qa<CR>", { desc = "[Q]uit No Save" })
m("n", "<C-c>", ":close<CR>", { desc = "[C]lose" })
m("n", "<Leader>yy", ":%y+<CR>", { desc = "[Y]ank buffer" })

m("n", "H", ":bprev<CR>", { desc = "Prev Buffer", noremap = false })
m("n", "L", ":bnext<CR>", { desc = "Next Buffer", noremap = false })

m("n", "=", [[:vertical resize +5<CR>]]) -- make the window bigger vertically
m("n", "-", [[:vertical resize -5<CR>]]) -- make the window smaller vertically
m("n", "+", [[:horizontal resize +2<CR>]]) -- make the window bigger horizontally
m("n", "_", [[:horizontal resize -2<CR>]]) -- make the window smaller horizontally

-- go to beginning and end
m("i", "<C-b>", "<ESC>^i", { desc = "Beginning of Line" })
m("i", "<C-e>", "<End>", { desc = "End of Line" })
m({ "n", "o", "x" }, "B", "^", { desc = "Beginning of Line" })
m({ "n", "o", "x" }, "E", "g_", { desc = "End of Line" })

-- Delete the character to the right of the cursor
m("i", "<C-D>", "<DEL>")

-- navigate within insert mode
m("i", "<C-h>", "<Left>", { desc = "Move Left" })
m("i", "<C-l>", "<Right>", { desc = "Move Right" })
m("i", "<C-j>", "<Down>", { desc = "Move Down" })
m("i", "<C-k>", "<Up>", { desc = "Move Up" })

-- turn the word under cursor to upper case
m("i", "<C-u>", "<Esc>viwUea", { desc = "Turn Into Upper Case" })
-- turn the current word into title case
m("i", "<C-t>", "<Esc>b~lea", { desc = "Turn Into Title Case" })

-- window management
m("n", "|", "<C-w>v", { desc = "Split Vertically" })
m("n", "\\", "<C-w>s", { desc = "Split Horizontally" })

-- clear highlights
m("n", "<Esc>", ":noh<CR>", { desc = "Clear Highlights" })

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using : :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
m({ "n", "x" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move Down", expr = true })
m({ "n", "x" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move Up", expr = true })
m({ "n", "v" }, "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move Up", expr = true })
m({ "n", "v" }, "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move Down", expr = true })

-- Line operation
m({ "x", "v" }, "<", "<gv", { desc = "Indent Line" })
m({ "x", "v" }, ">", ">gv", { desc = "Indent Line" })
m("v", "J", ":move '>+1<CR>gv-gv", { desc = "Move Text Down" })
m("v", "K", ":move '<-2<CR>gv-gv", { desc = "Move Text Up" })

-- Change text without putting it into register,
-- see https://stackoverflow.com/q/54255/6064933
m("n", "c", '"_c')
m("n", "C", '"_C')
m("n", "cc", '"_cc')
m("x", "c", '"_c')

-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
m("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Don't Copy Replaced Text" })

-- commenting
m("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
m("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
