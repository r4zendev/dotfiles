return {
  "numToStr/Navigator.nvim",
  cmd = {
    "NavigatorLeft",
    "NavigatorDown",
    "NavigatorUp",
    "NavigatorRight",
    "NavigatorPrevious",
  },
  opts = {
    auto_save = nil,
  },
  keys = {
    { "<c-h>", vim.cmd.NavigatorLeft },
    { "<c-j>", vim.cmd.NavigatorDown },
    { "<c-k>", vim.cmd.NavigatorUp },
    { "<c-l>", vim.cmd.NavigatorRight },
  },
}
