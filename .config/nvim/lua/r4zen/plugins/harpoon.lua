local utils = require("r4zen.utils")

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")
    local tabby = require("tabby")

    harpoon:setup({
      settings = {
        -- save_on_toggle = true,
      },
    })

    local list = harpoon:list()

    vim.keymap.set("n", "<leader>j", function()
      list:remove()
    end)
    vim.keymap.set("n", "<leader>k", function()
      list:add()
    end)
    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(list)
    end)

    local function select_valid_index(direction)
      local idx = list._index

      -- Normalize the list only once
      local normalized_list = utils.normalize_table(list.items)

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

    -- for i = 1, 9 do
    --   print("<C-" .. i .. ">")
    --   vim.keymap.set("n", "<C-" .. i .. ">", function()
    --     require("harpoon"):list():select(i)
    --   end)
    -- end

    -- Tab-like experience
    harpoon:extend({
      ADD = function(cx)
        list._index = cx.idx
        tabby.update()
      end,
      REMOVE = function()
        list._index = #list.items + 1
        tabby.update()
      end,
      SELECT = function(cx)
        list._index = cx.idx
        tabby.update()
      end,
      LIST_CHANGE = function()
        tabby.update()
      end,
      -- extensions.builtins.navigate_with_number()
      UI_CREATE = function(cx)
        for i = 1, 9 do
          vim.keymap.set("n", "" .. i, function()
            require("harpoon"):list():select(i)
          end, { buffer = cx.bufnr })
        end
      end,
    })
  end,
}
