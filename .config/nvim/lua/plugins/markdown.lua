return {
  {
    "bullets-vim/bullets.vim",
    ft = { "markdown", "text", "gitcommit", "scratch" },
    init = function()
      vim.g.bullets_delete_last_bullet_if_empty = 2
    end,
  },
  {
    "jghauser/follow-md-links.nvim",
    ft = "markdown",
  },
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    cmd = "Markview",
    keys = {
      { "<leader>mT", "<cmd>Markview toggle<cr>", desc = "Toggle Markview" },
    },
    opts = {},
  },
  {
    "brianhuster/live-preview.nvim",
    event = "VeryLazy",
    opts = {
      picker = "snacks.picker",
    },
    keys = {
      {
        "<leader>mp",
        function()
          local livepreview = require("livepreview")

          if livepreview.is_running() then
            vim.cmd("silent LivePreview close")
            vim.cmd("silent LivePreview start")
          else
            vim.cmd("silent LivePreview start")
          end
        end,
        desc = "Start LivePreview server",
      },
      {
        "<leader>ms",
        function()
          vim.cmd("silent LivePreview close")
        end,
        desc = "Stop LivePreview server",
      },
    },
  },
  -- {
  --   "iamcco/markdown-preview.nvim",
  --   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  --   ft = "markdown",
  --   build = function()
  --     vim.fn["mkdp#util#install"]()
  --   end,
  --   keys = {
  --     { "<leader>mp", vim.cmd.MarkdownPreview, desc = "Preview Markdown" },
  --   },
  -- },
}
