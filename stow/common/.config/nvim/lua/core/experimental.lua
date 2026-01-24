require("vim._extui").enable({})

vim.cmd([[cnoreabbrev <expr> w getcmdtype() == ":" && getcmdline() == "w" ? "silent w" : "w"]])
vim.cmd([[cnoreabbrev <expr> wq getcmdtype() == ":" && getcmdline() == "wq" ? "silent wq" : "wq"]])
vim.cmd([[cnoreabbrev <expr> wa getcmdtype() == ":" && getcmdline() == "wa" ? "silent wa" : "wa"]])

vim.o.cmdheight = 0
vim.o.report = 99999

-- NOTE: use in case authors don't update their plugins in time to suppress deprecation warnings
---@diagnostic disable-next-line: duplicate-set-field
-- vim.deprecate = function() end
