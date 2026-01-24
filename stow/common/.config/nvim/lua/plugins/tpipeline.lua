return {
  "vimpostor/vim-tpipeline",
  lazy = false,
  init = function()
    -- Fish causes lag while maximizing pane
    -- Snacks terminal still uses fish nonetheless
    vim.opt.cmdheight = 0
    vim.opt.shell = vim.g.is_darwin and "/opt/homebrew/bin/bash" or "/usr/bin/bash"
  end,
}
