-- Testing one two
return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>ea",
      function()
        local manager = require("neo-tree.sources.manager")
        local state = manager.get_state("filesystem")

        if state.winid and vim.api.nvim_win_is_valid(state.winid) then
          require("neo-tree.command").execute({ action = "close" })
          return
        end

        local reveal_file = vim.fn.expand("%:p")
        if reveal_file == "" then
          reveal_file = vim.fn.getcwd()
        else
          local f = io.open(reveal_file, "r")
          if f then
            f:close()
          else
            reveal_file = vim.fn.getcwd()
          end
        end

        require("neo-tree.command").execute({
          action = "focus",
          source = "filesystem",
          position = "left",
          reveal_file = reveal_file,
          reveal_force_cwd = true,
        })
      end,
      desc = "Toggle Neo Tree",
    },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
      },
    },
  },
}
