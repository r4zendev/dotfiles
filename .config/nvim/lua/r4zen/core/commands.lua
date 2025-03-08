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
