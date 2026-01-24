return {
  "vimpostor/vim-tpipeline",
  lazy = false,
  init = function()
    -- Fish causes lag while maximizing pane
    -- Snacks terminal still uses fish nonetheless
    vim.opt.shell = "/usr/bin/bash"
  end,
}
