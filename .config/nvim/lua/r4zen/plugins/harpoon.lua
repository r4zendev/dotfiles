return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup({
      settings = {
        -- save_on_toggle = true,
      },
    })

    vim.keymap.set("n", "<leader>j", function()
      harpoon:list():remove()
    end)
    vim.keymap.set("n", "<leader>k", function()
      harpoon:list():add()
    end)
    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    local function select_valid_index(direction)
      local list = harpoon:list()
      local idx = list._index

      print("Initial index:", idx, "Direction:", direction)

      local step = direction == "prev" and -1 or 1
      local start_idx = idx + step

      for i = start_idx, (direction == "prev" and 1 or #list.items), step do
        local item = list:get(i)
        print("Checking index:", i, "Value:", item and item.value or "nil")

        if item and item.value then
          list:select(i)
          list._index = i -- Ensure _index is updated manually, probably a bug in harpoon idk
          print("New selected index:", list._index)
          return
        end
      end

      local wrap_start = (direction == "prev") and #list.items or 1
      local wrap_end = (direction == "prev") and 1 or #list.items
      local wrap_step = (direction == "prev") and -1 or 1

      for i = wrap_start, wrap_end, wrap_step do
        local item = list:get(i)
        print("Wrapping check index:", i, "Value:", item and item.value or "nil")

        if item and item.value then
          list:select(i)
          list._index = i
          print("Wrapped selection to index:", list._index)
          return
        end
      end
    end

    vim.keymap.set("n", "<C-_>", function()
      select_valid_index("prev")
    end)
    vim.keymap.set("n", "<C-]>", function()
      select_valid_index("next")
    end)
  end,
}
