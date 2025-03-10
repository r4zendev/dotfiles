return {
  "github/copilot.vim",
  enabled = true,
  event = { "BufReadPost", "BufNewFile" },
  init = function()
    vim.g.copilot_no_tab_map = false
    vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
  end,
}
