local utils = require("r4zen.utils")

--------------------------------------------------
-- Harpoon File Utilities
--------------------------------------------------
local function get_harpooned_files()
  local harpoon = require("harpoon")
  local file_list = {}

  for idx, item in ipairs(vim.tbl_values(harpoon:list().items)) do
    local item_fn, item_ext = utils.get_fname_parts(item.value)
    table.insert(file_list, string.format("[%s] %s%s", idx, item_fn, item_ext))
  end

  return file_list
end

local function get_current_index()
  local harpoon = require("harpoon")
  local current_file = vim.fn.bufname()

  for index, item in ipairs(vim.tbl_values(harpoon:list().items)) do
    if vim.uv.fs_realpath(item.value) == vim.uv.fs_realpath(current_file) then
      return index
    end
  end
end

--------------------------------------------------
-- UI Status Management
--------------------------------------------------
local status_timer
local status_window
local disappear_delay = 1200

local function close_status_window()
  if status_window then
    vim.api.nvim_win_close(status_window, true)
    status_timer = nil
  end
end

local function show_status_ui()
  local buf = vim.api.nvim_create_buf(false, true)
  local content = get_harpooned_files()

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

  local current_index = get_current_index()

  for idx, _ in ipairs(content) do
    local color = "HarpoonOptionHL"
    if idx == current_index then
      color = "HarpoonSelectedOptionHL"
      vim.api.nvim_buf_set_extmark(
        buf,
        vim.api.nvim_create_namespace("HarpoonHighlights"),
        idx - 1,
        0,
        { line_hl_group = color, end_row = idx - 1 }
      )
    end
  end

  -- Calculate dimensions
  local height = math.max(1, math.min(#content, vim.o.lines - 3))

  local width = 0
  for _, line in pairs(content) do
    width = math.max(width, #line)
  end
  width = math.min(width + 2, vim.o.columns - 2)

  local opts = {
    relative = "win",
    anchor = "NE",
    col = vim.o.columns,
    row = 2,
    width = width,
    height = height,
    focusable = false,
    style = "minimal",
  }

  status_window = vim.api.nvim_open_win(buf, false, opts)
  vim.api.nvim_set_option_value("winhighlight", "Normal:HarpoonPanelHL", { win = status_window })
end

local function trigger_status_ui()
  if status_timer then
    vim.fn.timer_stop(status_timer)
    close_status_window()
  end

  show_status_ui()
  status_timer = vim.fn.timer_start(disappear_delay, close_status_window)
end

--------------------------------------------------
-- Plugin Configuration
--------------------------------------------------
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  -- Don't lazy load in order to display marks list on startup
  lazy = false,
  -- Replace lazy = false with this to lazy load (removes UI on startup)
  -- event = "VeryLazy",
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

    local list = harpoon:list()

    local function select_valid_index(direction)
      if #list.items == 0 then
        return
      end

      local idx = list._index

      -- Normalize the list only once
      local normalized_list = vim.tbl_values(list.items)

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
          trigger_status_ui()

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

    -- Key mappings
    vim.keymap.set("n", "<leader>j", function()
      list:remove()
    end, { desc = "Harpoon remove" })

    vim.keymap.set("n", "<leader>k", function()
      list:add()
    end, { desc = "Harpoon add" })

    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(list)
    end, { desc = "Harpoon menu" })

    vim.keymap.set("n", "<M-]>", function()
      select_valid_index("next")
    end, { desc = "Harpoon next" })

    vim.keymap.set("n", "<M-[>", function()
      select_valid_index("prev")
    end, { desc = "Harpoon previous" })

    require("which-key").add({
      { "<leader>j", icon = { icon = "-", color = "red" } },
      { "<leader>k", icon = { icon = "+", color = "green" } },
    })

    -- Number key mappings for quick access
    for i = 1, 9 do
      vim.keymap.set("n", "<c-t>" .. i, function()
        require("harpoon"):list():select(i)
      end, { desc = string.format("Harpoon: Go to %s", i) })
    end

    -- Extend harpoon with custom hooks
    harpoon:extend({
      ADD = function()
        list._index = #list.items
        trigger_status_ui()
      end,
      REMOVE = function()
        trigger_status_ui()
      end,
      SELECT = function(cx)
        list._index = cx.idx
        vim.api.nvim_feedkeys("zz", "n", false)
      end,
      NAVIGATE = function()
        trigger_status_ui()
      end,
      -- UI number key mappings
      UI_CREATE = function(cx)
        for i = 1, 9 do
          vim.keymap.set("n", "" .. i, function()
            require("harpoon"):list():select(i)
          end, { buffer = cx.bufnr })
        end
      end,
    })

    -- Show UI on startup
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        trigger_status_ui()
      end,
    })
  end,
}
