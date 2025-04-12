local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)

augroup("JSLogMacro", { clear = true })
autocmd("FileType", {
  group = "JSLogMacro",
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa: ', " .. esc .. "pa);")
  end,
})
