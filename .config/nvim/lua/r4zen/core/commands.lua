local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local HighlightOnYankGroup = augroup("HighlightOnYank", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
  group = HighlightOnYankGroup,
  pattern = "*",
  desc = "Highlight text when yank",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Reload the file if it changes externally
autocmd({ "FileChangedShell", "FocusGained" }, {
  pattern = "*",
  callback = function()
    vim.cmd("silent! checktime")
  end,
})

-- Also reload after a short delay when saving.
-- Some external tooling may modify it and the autocmd above won't work.
-- Useful for working with likes of TanStack Router
autocmd("BufWritePost", {
  pattern = "*",
  callback = function()
    -- Delay the reload to allow the external process to modify the file
    vim.defer_fn(function()
      vim.cmd("silent! checktime")
    end, 500)
  end,
})

-- Kill daemons manually until core_d provides this functionality.
autocmd("VimLeavePre", {
  callback = function()
    vim.fn.jobstart("killall prettierd eslint_d", { detach = true })
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
