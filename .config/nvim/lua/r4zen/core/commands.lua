local utils = require("r4zen.utils")

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

-- Reload the file if it changes externally
vim.api.nvim_create_autocmd({ "FileChangedShell", "FocusGained" }, {
  pattern = "*",
  callback = function()
    vim.cmd("checktime")
  end,
})

-- Also reload after a short delay when saving.
-- Some external tooling may modify it and the autocmd above won't work.
-- Useful for working with likes of TanStack Router
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  callback = function()
    -- Delay the reload to allow the external process to modify the file
    vim.defer_fn(function()
      vim.cmd("silent! checktime")
    end, 500)
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

-- load buffer into memory snippet
-- local bufnr = vim.api.nvim_create_buf(true, false)
-- vim.api.nvim_buf_set_name(bufnr, path)
-- vim.api.nvim_buf_call(bufnr, vim.cmd.edit)
