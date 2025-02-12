return {
  "MagicDuck/grug-far.nvim",
  config = function()
    local grug_far = require("grug-far")

    grug_far.setup({
      prefills = {
        flags = "--multiline --smart-case --hidden --sortr=modified",
      },
      keymaps = {
        openNextLocation = { n = "<C-j>" },
        openPrevLocation = { n = "<C-k>" },
      },
    })

    vim.keymap.set("v", "<leader>fv", function()
      grug_far.with_visual_selection()
    end, { desc = "Search for selected text" })

    vim.keymap.set("n", "<leader>fs", function()
      grug_far.open()
    end, { desc = "Search and replace" })

    --
    -- vim.keymap.set("n", "<C-j>", function()
    --   grug_far.open_next_location()
    -- end, { desc = "Search and replace" })
    --
    -- vim.keymap.set("n", "<C-k>", function()
    --   grug_far.open_prev_location()
    -- end, { desc = "Search and replace" })
  end,
}
