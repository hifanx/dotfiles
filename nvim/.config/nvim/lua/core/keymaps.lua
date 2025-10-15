-- basic
vim.keymap.set('n', '<C-s>', ':w<CR>', { desc = '[W]rite' })
vim.keymap.set('n', '<C-q>', ':qa<CR>', { desc = '[Q]uit No Save' })
vim.keymap.set('n', '<C-c>', ':close<CR>', { desc = '[C]lose' })
vim.keymap.set('n', '<Leader>y', ':%y+<CR>', { desc = '[Y]ank buffer' })

vim.keymap.set('n', 'H', ':bprev<CR>', { desc = 'Prev Buffer', noremap = false })
vim.keymap.set('n', 'L', ':bnext<CR>', { desc = 'Next Buffer', noremap = false })

vim.keymap.set('n', '=', [[:vertical resize +5<CR>]])
vim.keymap.set('n', '-', [[:vertical resize -5<CR>]])
vim.keymap.set('n', '+', [[:horizontal resize +2<CR>]])
vim.keymap.set('n', '_', [[:horizontal resize -2<CR>]])

-- go to beginning and end
vim.keymap.set('i', '<C-b>', '<ESC>^i', { desc = 'Beginning of Line' })
vim.keymap.set('i', '<C-e>', '<End>', { desc = 'End of Line' })
vim.keymap.set({ 'n', 'o', 'x' }, 'B', '^', { desc = 'Beginning of Line' })
vim.keymap.set({ 'n', 'o', 'x' }, 'E', 'g_', { desc = 'End of Line' })

-- Delete the character to the right of the cursor
vim.keymap.set('i', '<C-D>', '<DEL>')

-- navigate within insert mode
vim.keymap.set('i', '<C-h>', '<Left>', { desc = 'Move Left' })
vim.keymap.set('i', '<C-l>', '<Right>', { desc = 'Move Right' })
vim.keymap.set('i', '<C-j>', '<Down>', { desc = 'Move Down' })
vim.keymap.set('i', '<C-k>', '<Up>', { desc = 'Move Up' })

-- turn the word under cursor to upper case
vim.keymap.set('i', '<C-u>', '<Esc>viwUea', { desc = 'Turn Into Upper Case' })
-- turn the current word into title case
vim.keymap.set('i', '<C-t>', '<Esc>b~lea', { desc = 'Turn Into Title Case' })

-- window management
vim.keymap.set('n', '|', '<C-w>v', { desc = 'Split Vertically' })
vim.keymap.set('n', '\\', '<C-w>s', { desc = 'Split Horizontally' })

-- clear highlights
vim.keymap.set('n', '<Esc>', ':noh<CR>', { desc = 'Clear Highlights' })

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using : :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
vim.keymap.set({ 'n', 'x' }, 'j', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = 'Move Down', expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = 'Move Up', expr = true })
vim.keymap.set({ 'n', 'v' }, '<Up>', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = 'Move Up', expr = true })
vim.keymap.set(
  { 'n', 'v' },
  '<Down>',
  'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
  { desc = 'Move Down', expr = true }
)

-- Line operation
vim.keymap.set({ 'x', 'v' }, '<', '<gv', { desc = 'Indent Line' })
vim.keymap.set({ 'x', 'v' }, '>', '>gv', { desc = 'Indent Line' })
vim.keymap.set('v', 'J', ":move '>+1<CR>gv-gv", { desc = 'Move Text Down' })
vim.keymap.set('v', 'K', ":move '<-2<CR>gv-gv", { desc = 'Move Text Up' })

-- Change text without putting it into register,
-- see https://stackoverflow.com/q/54255/6064933
vim.keymap.set('n', 'c', '"_c')
vim.keymap.set('n', 'C', '"_C')
vim.keymap.set('n', 'cc', '"_cc')
vim.keymap.set('x', 'c', '"_c')

-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
vim.keymap.set('x', 'p', 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Don't Copy Replaced Text" })

-- commenting
vim.keymap.set('n', 'gco', 'o<esc>Vcx<esc>:normal gcc<CR>fxa<bs>', { desc = 'Add Comment Below' })
vim.keymap.set('n', 'gcO', 'O<esc>Vcx<esc>:normal gcc<CR>fxa<bs>', { desc = 'Add Comment Above' })
