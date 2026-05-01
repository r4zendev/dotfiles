return {
  "vimpostor/vim-tpipeline",
  enabled = vim.g.is_linux and vim.uv.getuid() ~= 0,
  lazy = false,
  init = function()
    -- Fish causes lag while maximizing pane
    -- Snacks terminal still uses fish nonetheless
    vim.opt.shell = vim.g.is_darwin and "/opt/homebrew/bin/bash" or "/usr/bin/bash"
    vim.opt.cmdheight = 0
    vim.g.tpipeline_autoembed = 0
    vim.g.tpipeline_refreshcmd = ""
  end,
}
