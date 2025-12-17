local autocmd = vim.api.nvim_create_autocmd

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
  pattern = {
    "help",
    "man",
    "qf",
    "lspinfo",
    "git",
    "copilot",
    "grug-far",
    "vim",
    "fugitive",
    -- "codecompanion"
  },
  callback = function()
    vim.bo.buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", "<cmd>quit<CR>", { buffer = true, silent = true })
    end)
  end,
})

-- Add empty winbar to align with main window (useful for comparable views)
autocmd("FileType", {
  pattern = { "fugitiveblame" },
  callback = function()
    vim.wo.winbar = " "
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

-- Highlight on yank, currently handled by yanky.nvim
-- autocmd("TextYankPost", {
--   -- group = augroup("HighlightOnYank", { clear = true }),
--   pattern = "*",
--   desc = "Highlight text when yank",
--   callback = function()
--     vim.hl.on_yank()
--   end,
-- })

-- Create parent directories on save, currently handled by custom 'W' command
-- autocmd("BufWritePre", {
--   group = vim.api.nvim_create_augroup("MkdirOnSave", { clear = true }),
--   callback = function(args)
--     local dir = vim.fn.fnamemodify(args.file, ":p:h")
--
--     -- skip URLs (netrw)
--     if dir:find("%l+://") == 1 then
--       return
--     end
--
--     if vim.fn.isdirectory(dir) == 0 then
--       vim.fn.mkdir(dir, "p")
--     end
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
