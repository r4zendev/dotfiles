local utils = require("r4zen.utils")

local M = {}

M.plugin = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  lazy = false,
  -- Replace with this to lazy load (removes UI on startup)
  -- event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- stylua: ignore
  keys = {
    { "<leader>j", function() require("harpoon"):list():remove() end, desc = "Harpoon: Remove" },
    { "<leader>k", function() require("harpoon"):list():add() end, desc = "Harpoon: Add" },
    { "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon: Toggle UI" },
    { "<M-[>", function() M.select_valid_index("prev") end, desc = "Harpoon: Previous" },
    { "<M-]>", function() M.select_valid_index("next") end, desc = "Harpoon: Next" },
  },
  init = function()
    local map = vim.keymap.set

    -- Number key mappings for quick access
    for i = 1, 9 do
      map("n", "<c-t>" .. i, function()
        require("harpoon"):list():select(i)
      end, { desc = string.format("Harpoon: Go to %s", i) })
    end

    -- Show UI on startup
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        M.trigger_status_ui()
      end,
    })

    require("harpoon"):extend({
      ADD = function()
        local list = require("harpoon"):list()
        list._index = #list.items
        M.trigger_status_ui()
      end,
      REMOVE = function()
        M.trigger_status_ui()
      end,
      SELECT = function(cx)
        local list = require("harpoon"):list()
        list._index = cx.idx
        vim.api.nvim_feedkeys("zz", "n", false)
      end,
      NAVIGATE = function()
        M.trigger_status_ui()
      end,
      -- UI number key mappings
      UI_CREATE = function(cx)
        for i = 1, 9 do
          map("n", tostring(i), function()
            require("harpoon"):list():select(i)
          end, { buffer = cx.bufnr })
        end
      end,
    })
  end,
}

M.select_valid_index = function(direction)
  local list = require("harpoon"):list()

  if #list.items == 0 then
    return
  end

  local idx = list._index

  local normalized_list = vim.tbl_values(list.items)
  list.items = normalized_list

  local step = direction == "prev" and -1 or 1
  local total_items = #normalized_list
  local start_idx = (idx - 1 + step) % total_items + 1

  local i = start_idx
  local loop_start_idx = start_idx

  while true do
    local item = normalized_list[i]

    if item then
      list:select(i)
      M.trigger_status_ui()

      list._index = i
      return
    end

    i = (i + step - 1) % total_items + 1

    if i == loop_start_idx then
      break
    end
  end
end

M.get_harpooned_files = function()
  local harpoon = require("harpoon")
  local file_list = {}

  for idx, item in ipairs(vim.tbl_values(harpoon:list().items)) do
    local item_fn, item_ext = utils.get_fname_parts(item.value)
    table.insert(file_list, string.format("[%s] %s%s", idx, item_fn, item_ext))
  end

  return file_list
end

M.get_current_index = function()
  local harpoon = require("harpoon")
  local current_file = vim.fn.bufname()

  for index, item in ipairs(vim.tbl_values(harpoon:list().items)) do
    local mark_path = vim.uv.fs_realpath(item.value)
    local current_path = vim.uv.fs_realpath(current_file)

    if mark_path and current_path and mark_path == current_path then
      return index
    end
  end
end

local status_timer
local status_window
local disappear_delay = 1200

M.close_status_window = function()
  if status_window then
    vim.api.nvim_win_close(status_window, true)
    status_timer = nil
  end
end

M.show_status_ui = function()
  local buf = vim.api.nvim_create_buf(false, true)
  local content = M.get_harpooned_files()

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

  local current_index = M.get_current_index()

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

M.trigger_status_ui = function()
  if status_timer then
    vim.fn.timer_stop(status_timer)
    M.close_status_window()
  end

  M.show_status_ui()
  status_timer = vim.fn.timer_start(disappear_delay, M.close_status_window)
end

return M.plugin
