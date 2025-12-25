return {
  "github/copilot.vim",
  cmd = "Copilot",
  event = "LazyFile",
  keys = {
    { "<leader>ap", "<cmd>Copilot<cr>", desc = "Copilot: Open Panel" },
    { "<c-w>", "<Plug>(copilot-accept-word)", mode = "i", desc = "Copilot: Accept Word" },
    { "<c-l>", "<Plug>(copilot-accept-line)", mode = "i", desc = "Copilot: Accept Line" },
    { "[[", "<Plug>(copilot-previous)", mode = "i", desc = "Copilot: Previous Suggestion" },
    { "]]", "<Plug>(copilot-next)", mode = "i", desc = "Copilot: Next Suggestion" },
  },
  init = function()
    vim.g.copilot_enabled = true
    vim.g.copilot_workspace_folders = { require("utils").workspace_root() }
  end,
}
