-- set leader key to space
vim.g.mapleader = " "
vim.g.VM_leader = ","
-- vim.g.maplocalleader = ","

-- use jk to exit insert mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- re-enter visual after moving a visual block
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("n", "x", '"_x') -- delete single character without copying into register
vim.keymap.set("n", "<leader>sc", ':let @/ = ""<CR>', { desc = "Clear search" }) -- clear search highlights
vim.keymap.set("n", "<leader>cw", ':let @+ = expand("%:p")<CR>', { desc = "Copy buffer's path" }) -- copy path

-- remap arrows to hjkl to be able to use them in my glove80 layout with custom alphas (graphite)
vim.keymap.set({ "n", "v" }, "<Left>", "h")
vim.keymap.set({ "n", "v" }, "<Down>", "j")
vim.keymap.set({ "n", "v" }, "<Up>", "k")
vim.keymap.set({ "n", "v" }, "<Right>", "l")

-- increment/decrement numbers (kinda useless)
-- vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
-- vim.keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
vim.keymap.set("n", "<leader>-", "20<C-w><", { desc = "Shrink window" })
vim.keymap.set("n", "<leader>=", "20<C-w>>", { desc = "Grow window" })

vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
