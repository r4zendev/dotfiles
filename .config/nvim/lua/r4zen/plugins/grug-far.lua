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
        require("grug-far").toggle_instance({ instanceName = "far", staticTitle = "Find and Replace" })
      end,
      mode = { "n", "v" },
      desc = "Search and replace",
    },
    -- Currently not used, due to it causing a weird bug that crashes Neovim
    -- grug-far doesn't seem to untrack its window and keeps searching for its
    -- window ID when it's not available anymore.
    -- {
    --   "<leader>fx",
    --   function()
    --     require("grug-far").close_instance("far")
    --   end,
    --   mode = { "n", "v" },
    --   desc = "Close FAR instance",
    -- },
  },
}
