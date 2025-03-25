-- HACK: While using nightly build, it's quite annoying to see deprecation errors on startup.
-- contextfiles.nvim plugin makes use of vim.glob.to_lpeg() function which has an obvious bug
-- in Neovim 0.11.4 that can only be resolved by upgrading to nightly.
-- TODO: When Neovim 0.12 is released and plugins are fixed, this can be removed.
-- This warning seemingly comes from lspconfig
vim.deprecate = function() end

require("r4zen.core")
require("r4zen.lazy")
