local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

local M = {}

M.navigate = function(direction)
  local win = vim.api.nvim_get_current_win()
  vim.cmd.wincmd(direction)
  if vim.api.nvim_get_current_win() == win and vim.env.TMUX then
    local tmux_dir = ({ h = "L", j = "D", k = "U", l = "R" })[direction]
    vim.system({ "tmux", "select-pane", "-" .. tmux_dir }):wait()
  end
end

map({ "n", "x", "t" }, "<C-h>", function()
  M.navigate("h")
end)
map({ "n", "x", "t" }, "<C-j>", function()
  M.navigate("j")
end)
map({ "n", "x", "t" }, "<C-k>", function()
  M.navigate("k")
end)
map({ "n", "x", "t" }, "<C-l>", function()
  M.navigate("l")
end)

-- Move tmux status bar to top when entering vim, bottom when exiting
if vim.env.TMUX and vim.env.TMUX_STATUS_DYNAMIC == "1" then
  autocmd("VimEnter", {
    callback = function()
      vim.fn.jobstart("tmux set status-position top", { detach = true })
    end,
  })

  autocmd("VimLeavePre", {
    callback = function()
      vim.fn.jobstart("tmux set status-position bottom", { detach = true })
    end,
  })
end

return M
