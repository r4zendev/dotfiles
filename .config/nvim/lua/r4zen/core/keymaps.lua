local keymap = vim.keymap.set

-- set leader key to space
vim.g.mapleader = " "

-- use jk to exit insert mode
keymap("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })

-- re-enter visual after moving a visual block
keymap("v", ">", ">gv")
keymap("v", "<", "<gv")

-- remap arrows to hjkl
keymap({ "n", "v" }, "<Left>", "h", { noremap = true, silent = true })
keymap({ "n", "v" }, "<Down>", "j", { noremap = true, silent = true })
keymap({ "n", "v" }, "<Up>", "k", { noremap = true, silent = true })
keymap({ "n", "v" }, "<Right>", "l", { noremap = true, silent = true })

-- registers
keymap("n", "x", '"_x') -- delete char without polluting copy register by default
keymap("n", "<leader>sc", ':let @/ = ""<CR>', { desc = "Clear search" })
keymap("n", "<leader>yy", ':let @+ = expand("%:p")<CR>', { desc = "Copy buffer's path" })
keymap("n", "<leader>yr", ':let @+ = expand("%")<CR>', { desc = "Copy relative path" })
keymap("n", "<leader>pp", '"_cgn<C-r>"<Esc>', { desc = "Change next match with clipboard" }) -- (dot-repeatable)

-- repeat dot multiple times
keymap("n", "<leader>.", function()
  return "<esc>" .. string.rep(".", vim.v.count1)
end, { expr = true, desc = "Repeat dot action" })

-- remap increment
-- <C-a> is a tmux prefix
keymap("n", "<M-->", "<C-x>", { noremap = true, silent = true })
keymap("n", "<M-=>", "<C-a>", { noremap = true, silent = true })
keymap("n", "<C-a>", "<Nop>", { noremap = true, silent = true })
keymap("n", "<C-x>", "<Nop>", { noremap = true, silent = true })

-- center screen after paging
keymap({ "n", "v" }, "<C-u>", "<C-u>zz", { noremap = true, silent = true })
keymap({ "n", "v" }, "<C-d>", "<C-d>zz", { noremap = true, silent = true })

-- window management

-- split window vertically
keymap("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
-- split window horizontally
keymap("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
-- make splits equal width & height
keymap("n", "<leader>w=", "<C-w>=", { desc = "Make splits equal size" })
-- close current split
keymap("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current split" })
-- open current split in a new tab (maximize), :q to de-maximize
keymap("n", "<leader>wm", "<cmd>tab split<CR>", { desc = "Open split in new tab" })
-- resize split
keymap("n", "<C-Left>", "5<C-w><", { desc = "Width shrink" })
keymap("n", "<C-Right>", "5<C-w>>", { desc = "Width grow" })
keymap("n", "<C-Up>", "5<C-w>+", { desc = "Height shrink" })
keymap("n", "<C-Down>", "5<C-w>-", { desc = "Height grow" })

-- currently trying to use ZZ/ZQ instead
--
-- keymap("n", "<leader>q", ":q<cr>", { desc = "Quit all" })
-- keymap("n", "<leader>w", ":w<cr>", { desc = "Save and quit all" })

-- prolly should just learn to press (* or #) with (`` or Ctrl-N) fast
--
-- keymap({ "n", "v" }, "<leader>8", function()
--   if vim.fn.mode() == "v" then
--     vim.cmd('normal! "vy')
--     vim.fn.setreg("/", vim.fn.escape(vim.fn.getreg("v"), "\\/"))
--     vim.cmd("redraw")
--   else
--     vim.cmd("keepjumps normal! mi*`i") -- same as *`` but without moving the cursor (?)
--   end
-- end, { noremap = true, silent = true, desc = "Jump to current" })

-- move in wrapped line, useful when vim.opt.wrap is set to true.
-- may break plugins if they rely on default j,k behavior.
-- in that case, it is better to map "gk" and "gj" to other keys:
-- keymap("n", "<Down>", "gj", { noremap = true, silent = true })
-- keymap("n", "<Up>", "gk", { noremap = true, silent = true })
--
-- keymap("n", "k", function()
--   return vim.v.count == 0 and "gk" or "k"
-- end, { expr = true })
-- keymap("n", "j", function()
--   return vim.v.count == 0 and "gj" or "j"
-- end, { expr = true })

-- bufferline is currently not used, instead a custom UI tailored to harpoon is implemented
--
-- open new tab
-- keymap("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
-- close current tab
-- keymap("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
-- go to next tab
-- keymap("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
-- go to previous tab
-- keymap("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
-- move current buffer to new tab
-- keymap("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
