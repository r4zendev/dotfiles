local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local HiglightOnYankGroup = augroup("HiglightOnYank", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
  group = HiglightOnYankGroup,
  pattern = "*",
  desc = "Highlight text when yank",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- <C-u> in insert mode to remove appended comment seems to work okay,
-- since there are still cases where auto-appended comments would be nice.
-- autocmd("BufEnter", {
--   pattern = "*",
--   desc = "Disable auto comment",
--   callback = function()
--     vim.opt.formatoptions:remove({ "c", "r", "o" })
--   end,
-- })
