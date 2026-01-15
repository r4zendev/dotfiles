local map = vim.keymap.set

local M = {}

M.navigate = function(direction)
  local win = vim.api.nvim_get_current_win()
  vim.cmd.wincmd(direction)
  if vim.api.nvim_get_current_win() == win and vim.env.TMUX then
    local tmux_dir = ({ h = "L", j = "D", k = "U", l = "R" })[direction]
    vim.system({ "tmux", "select-pane", "-" .. tmux_dir }):wait()
  end
end

map({ "n", "x" }, "<C-h>", function()
  M.navigate("h")
end)
map({ "n", "x" }, "<C-j>", function()
  M.navigate("j")
end)
map({ "n", "x" }, "<C-k>", function()
  M.navigate("k")
end)
map({ "n", "x" }, "<C-l>", function()
  M.navigate("l")
end)

return M
