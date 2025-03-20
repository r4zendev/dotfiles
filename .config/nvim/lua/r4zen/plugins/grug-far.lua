return {
  "MagicDuck/grug-far.nvim",
  opts = {
    prefills = {
      flags = "--multiline --smart-case --hidden --sortr=modified --fixed-strings",
      filesFilter = [[
!node_modules
!*-lock.{json,yaml}
!*.lock]],
    },
    keymaps = {
      replace = { n = "<leader>r" },
      openNextLocation = { n = "<C-j>" },
      openPrevLocation = { n = "<C-k>" },
    },
  },
  keys = {
    {
      "<leader>fs",
      function()
        -- TODO: close oil.nvim on open
        require("grug-far").open()
      end,
      mode = { "n" },
      desc = "Search and replace",
    },
    {
      "<leader>fs",
      function()
        require("grug-far").with_visual_selection()
      end,
      mode = { "v" },
      desc = "Search for selected text",
    },
  },
}
