local utils = require("r4zen.utils")

local status_timer
local status_window

local disappear_delay = 1200

local function close_status_window()
  if status_window then
    vim.api.nvim_win_close(status_window, true)
    status_timer = nil
  end
end

local function get_harpooned_files()
  local harpoon = require("harpoon")
  local file_list = {}

  for _, item in ipairs(utils.normalize_table(harpoon:list().items)) do
    local item_fn, item_ext = utils.get_file_name(item.value)
    table.insert(file_list, item_fn .. item_ext)
  end

  return file_list
end

local function get_current_index()
  local harpoon = require("harpoon")
  local current_file = vim.fn.bufname()
  local root_dir = harpoon:list().config:get_root_dir()

  for index, item in ipairs(utils.normalize_table(harpoon:list().items)) do
    local path = item.value

    if utils.is_relative_path(path) then
      path = utils.get_full_path(root_dir, path)
    end

    if utils.is_relative_path(current_file) then
      current_file = utils.get_full_path(root_dir, current_file)
    end

    if path == current_file then
      return index
    end
  end
end

local function show_status_ui()
  local buf = vim.api.nvim_create_buf(false, true)

  local content = get_harpooned_files()

  -- if #content == 0 then
  --     print("No harpooned files")
  --     return
  -- end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

  local current_index = get_current_index()

  for idx, _ in ipairs(content) do
    local color = "HarpoonOptionHL"
    if idx == current_index then
      color = "HarpoonSelectedOptionHL"
      vim.api.nvim_buf_add_highlight(buf, -1, color, idx - 1, 0, -1)
    end
  end

  local height = math.max(1, math.min(#content, vim.o.lines - 3))

  local width = 0
  for _, line in pairs(content) do
    width = math.max(width, #line)
  end
  width = math.min(width + 2, vim.o.columns - 2)
  local row = 2

  local opts = {
    relative = "win",
    anchor = "NE",
    col = vim.o.columns,
    row = row,
    width = width,
    height = height,
    focusable = false,
    style = "minimal",
  }

  status_window = vim.api.nvim_open_win(buf, false, opts)
  -- vim.api.nvim_win_set_option(status_window, "winhl", uiInfoHighlightGroup)

  vim.api.nvim_win_set_option(status_window, "winhighlight", "Normal:" .. "HarpoonFilesPanelHL")
end

local function trigger_status_ui()
  if status_timer then
    vim.fn.timer_stop(status_timer)
    close_status_window()
  end

  show_status_ui()
  status_timer = vim.fn.timer_start(disappear_delay, close_status_window)
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

    local list = harpoon:list()

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

    vim.keymap.set("n", "<leader>j", function()
      list:remove()
    end)
    vim.keymap.set("n", "<leader>k", function()
      list:add()
    end)
    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(list)
    end)
    vim.keymap.set("n", "<M-]>", function()
      select_valid_index("next")
    end)
    vim.keymap.set("n", "<M-[>", function()
      select_valid_index("prev")
    end)

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
      end,
      NAVIGATE = function()
        trigger_status_ui()
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
