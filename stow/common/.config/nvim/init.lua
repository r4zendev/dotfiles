require("core.init")

local uv = vim.uv or vim.loop
local uname = uv.os_uname().sysname
vim.g.is_darwin = uname == "Darwin"
vim.g.is_linux = uname == "Linux"

if vim.g.is_darwin then
  require("platform.darwin")
elseif vim.g.is_linux then
  require("platform.linux")
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local Event = require("lazy.core.handler.event")
Event.mappings.LazyFile =
  { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
Event.mappings["User LazyFile"] = Event.mappings.LazyFile

require("lazy").setup({
  { import = "plugins" },
  { import = "plugins.themes" },
}, {
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  defaults = { lazy = true },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    if not vim.g.loaded_tpipeline then
      print("tpipeline not found, using experimental UI")
      require("core.experimental")
    end
  end,
})

require("todo_list").setup({
  target_file = "~/notes/todo.md",
})
