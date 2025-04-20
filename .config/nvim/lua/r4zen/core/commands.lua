local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command
local utils = require("r4zen.utils")

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

-- Close windows with q
autocmd("FileType", {
  pattern = { "help", "man", "qf", "lspinfo", "git", "copilot", "grug-far", "vim", "codecompanion" },
  callback = function()
    vim.bo.buflisted = false
    vim.keymap.set("n", "q", "<cmd>quit<CR>", { buffer = true, silent = true })
  end,
})

-- Window layout
autocmd("FileType", {
  pattern = { "help", "qf", "copilot", "vim" },
  callback = function()
    -- Move to bottom (hJkl)
    -- vim.cmd("wincmd J")
    vim.cmd("horizontal resize 14")
  end,
})

-- LspInfo cmd from nvim-lspconfig
usercmd("LspInfo", function()
  vim.cmd("checkhealth vim.lsp")
end, { desc = "Show lsp info" })

-- Command to print open buffers and their filenames
usercmd("ShowBufs", function()
  local bufs = {}
  local bufnums = vim.api.nvim_list_bufs()
  for _, bufnum in ipairs(bufnums) do
    local bufname = vim.api.nvim_buf_get_name(bufnum)
    -- if vim.api.nvim_buf_is_loaded(bufnum) and bufname ~= "" and vim.bo[bufnum].buftype ~= "nofile" then
    if vim.api.nvim_buf_is_loaded(bufnum) and bufname ~= "" and utils.file_exists(bufname) then
      local home = os.getenv("HOME")
      if not home or bufname:sub(1, #home) == home then
        bufs[bufnum] = bufname
      end
    end
  end

  vim.schedule(function()
    local lines = {}
    for bufnum, bufname in pairs(bufs) do
      table.insert(lines, string.format("%d: %s", bufnum, bufname))
    end
    local message = table.concat(lines, "\n")
    vim.notify("Loaded file buffers:\n" .. message, vim.log.levels.INFO)
  end)
end, { desc = "Show open buffers" })

-- Highlight on yank, currently handled by yanky.nvim
-- autocmd("TextYankPost", {
--   -- group = augroup("HighlightOnYank", { clear = true }),
--   pattern = "*",
--   desc = "Highlight text when yank",
--   callback = function()
--     vim.hl.on_yank()
--   end,
-- })

-- <C-u> in insert mode to remove appended comment seems to work okay,
-- since there are still cases where auto-appended comments would be nice.
-- autocmd("BufEnter", {
--   pattern = "*",
--   desc = "Disable auto comment",
--   callback = function()
--     vim.opt.formatoptions:remove({ "c", "r", "o" })
--   end,
-- })
