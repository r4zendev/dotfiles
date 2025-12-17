local M = {}

---@type LazyFloat?
local terminal = nil

--- Opens an interactive floating terminal.
---@param cmd? string
---@param opts? LazyCmdOptions
function M.float_term(cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    ft = "lazyterm",
    size = { width = 0.7, height = 0.7 },
    persistent = true,
  }, opts or {})

  if terminal and terminal:buf_valid() and vim.b[terminal.buf].lazyterm_cmd == cmd then
    terminal:toggle()
  else
    terminal = require("lazy.util").float_term(cmd, opts)
    vim.b[terminal.buf].lazyterm_cmd = cmd
  end
end

return M

-- Example usage
--
-- map("n", "<leader>gg", function()
--   require("float_term").float_term("lazygit", {
--     size = { width = 0.85, height = 0.8 },
--     cwd = require("utils").workspace_root(),
--   })
-- end, { desc = "Open floating terminal" })

-- Example of opening a regular floating window (not term) with some kind of content
--
-- M.open_notifications_history = function(notifications)
--   local buf = vim.api.nvim_create_buf(false, true)
--
--   local width = math.floor(vim.o.columns * 0.8)
--   local height = math.floor(vim.o.lines * 0.8)
--   local col = math.floor((vim.o.columns - width) / 2)
--   local row = math.floor((vim.o.lines - height) / 2)
--
--   local win = vim.api.nvim_open_win(buf, true, {
--     relative = "editor",
--     width = width,
--     height = height,
--     col = col,
--     row = row,
--     style = "minimal",
--     border = "rounded",
--     title = " Notification History ",
--     title_pos = "center",
--   })
--
--   local lines = {}
--   for _, notif in ipairs(notifications) do
--     local msg = type(notif.msg) == "string" and notif.msg or vim.inspect(notif.msg)
--     msg = msg:gsub("%%", "%%%%") -- Escape literal '%'
--     msg = msg:gsub("\n", " ") -- Replace newlines with spaces
--     table.insert(lines, string.format("[%s] %s", notif.level, msg))
--   end
--
--   vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
--
--   vim.bo[buf].modifiable = false
--   vim.bo[buf].filetype = "log"
--   vim.bo[buf].bufhidden = "wipe"
--
--   map("n", "q", function()
--     vim.api.nvim_win_close(win, true)
--   end, { buffer = buf, silent = true, nowait = true, desc = "Close notification history" })
-- end
