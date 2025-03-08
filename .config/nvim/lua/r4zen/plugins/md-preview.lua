return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  config = function()
    vim.keymap.set("n", "<leader>md", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle Markdown Preview" })
  end,
}
