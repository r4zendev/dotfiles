-- set leader key to space
vim.g.mapleader = " "

-- use jk to exit insert mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- re-enter visual after moving a visual block
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- remap arrows to hjkl
vim.keymap.set({ "n", "v" }, "<Left>", "h")
vim.keymap.set({ "n", "v" }, "<Down>", "j")
vim.keymap.set({ "n", "v" }, "<Up>", "k")
vim.keymap.set({ "n", "v" }, "<Right>", "l")

-- registers
vim.keymap.set("n", "x", '"_x') -- delete char without polluting copy register by default
vim.keymap.set("n", "<leader>sc", ':let @/ = ""<CR>', { desc = "Clear search" })
vim.keymap.set("n", "<leader>yy", ':let @+ = expand("%:p")<CR>', { desc = "Copy buffer's path" })
vim.keymap.set("n", "<leader>yr", ':let @+ = expand("%")<CR>', { desc = "Copy relative path" })
vim.keymap.set("n", "<leader>gp", '"_cgn<C-r>"<Esc>', { desc = "Change next match with clipboard" }) -- (dot-repeatable)

-- repeat dot multiple times
vim.keymap.set("n", "<leader>.", function()
  return "<esc>" .. string.rep(".", vim.v.count1)
end, { expr = true })

-- remap increment due to using <C-a> as a tmux prefix
-- use <C-x> to decrement (default)
vim.keymap.set("n", "<C-b>", "<C-a>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-a>", "<Nop>", { noremap = true, silent = true })

-- center screen after paging
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })

-- window management

-- split window vertically
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
-- split window horizontally
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
-- make splits equal width & height
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
-- close current split
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
-- open current split in a new tab (maximize), :q to de-maximize
vim.keymap.set("n", "<leader>sm", "<cmd>tab split<CR>", { desc = "Open split in new tab" })
-- resize split
vim.keymap.set("n", "<C-Left>", "5<C-w><", { desc = "Width shrink" })
vim.keymap.set("n", "<C-Right>", "5<C-w>>", { desc = "Width grow" })
vim.keymap.set("n", "<C-Up>", "5<C-w>+", { desc = "Height shrink" })
vim.keymap.set("n", "<C-Down>", "5<C-w>-", { desc = "Height grow" })

-- move in wrapped line, useful when vim.opt.wrap is set to true.
-- may break plugins if they rely on default j,k behavior.
-- in that case, it is better to map "gk" and "gj" to other keys:
-- vim.keymap.set("n", "<Down>", "gj", { noremap = true, silent = true })
-- vim.keymap.set("n", "<Up>", "gk", { noremap = true, silent = true })
vim.keymap.set("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true })
vim.keymap.set("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true })

-- bufferline is currently not used, instead a custom UI tailored to harpoon is implemented

-- open new tab
-- vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
-- close current tab
-- vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
-- go to next tab
-- vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
-- go to previous tab
-- vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
-- move current buffer to new tab
-- vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
