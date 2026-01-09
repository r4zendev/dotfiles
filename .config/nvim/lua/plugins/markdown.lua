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
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>mp", vim.cmd.MarkdownPreview, desc = "Preview Markdown" },
    },
  },
}
