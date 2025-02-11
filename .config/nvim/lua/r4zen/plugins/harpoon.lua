local function normalizeTable(t)
  local newTable = {}
  for _, v in pairs(t) do
    table.insert(newTable, v)
  end
  return newTable
end

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

      -- Normalize the list only once
      local normalized_list = normalizeTable(list.items)

      -- Modify the original list to only contain valid items
      list.items = normalized_list

      -- Step for moving up or down the list
      local step = direction == "prev" and -1 or 1

      -- Calculate the total number of items in the normalized list
      local total_items = #normalized_list

      -- Calculate the starting index using modulo arithmetic for wrapping
      local start_idx = (idx - 1 + step) % total_items + 1

      -- Main loop to cycle through the normalized list
      local i = start_idx
      local loop_start_idx = start_idx -- Keep track of the initial index to detect a full cycle
      while true do
        local item = normalized_list[i]

        -- Only select valid items (the normalized list already filters out nils)
        if item then
          list:select(i)
          list._index = i
          return
        end

        -- Move to the next index in the loop (cycle to start or end if needed)
        i = (i + step - 1) % total_items + 1

        -- If we've cycled through and returned to the start index, we should stop
        if i == loop_start_idx then
          break
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
