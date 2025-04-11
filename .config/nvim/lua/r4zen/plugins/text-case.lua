local M = {}

M.plugin = {
  "johmsalas/text-case.nvim",
  event = "LazyFile",
  opts = { prefix = "<leader>C" },
  keys = {
    {
      "<leader>Ct",
      function()
        M.show_picker(M.picker_items, "Text Case: Rename Word", {
          current_word = require("textcase").current_word,
          visual = require("textcase").visual,
        })
      end,
      desc = "TextCase: Rename current word",
      mode = { "n", "v" },
    },
    {
      "<leader>CT",
      function()
        M.show_picker(M.picker_items, "Text Case: LSP Rename", {
          current_word = require("textcase").lsp_rename,
        })
      end,
      desc = "TextCase: LSP Rename",
      mode = { "n", "v" },
    },
  },
}

M.format_method_name = function(method)
  return method:gsub("_", " "):gsub("to ", ""):gsub("case", ""):gsub("^%l", string.upper):gsub("%s+$", "")
end

M.generate_picker_items = function(methods)
  local items = {}
  for _, method in ipairs(methods) do
    table.insert(items, { text = M.format_method_name(method), method = method })
  end
  return items
end

M.show_picker = function(items, title, callback_provider)
  -- Save current mode
  local mode = vim.api.nvim_get_mode().mode
  local is_visual = mode:sub(1, 1) == "v" or mode:sub(1, 1) == "V"

  -- Save visual marks if in visual mode
  if is_visual then
    -- This exits visual mode but saves the marks '< and '> for later use
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
  end

  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  vim.ui.select(items, {
    prompt = title,
    format_item = function(item)
      return item.text
    end,
  }, function(choice)
    if choice then
      -- Restore the cursor position
      vim.api.nvim_win_set_cursor(0, cursor_pos)

      -- Get the appropriate callback based on mode
      local callback
      if is_visual then
        -- For visual mode, we need to reselect the visual selection first
        vim.cmd("normal! gv")
        callback = callback_provider.visual
      else
        callback = callback_provider.current_word
      end

      if not callback then
        vim.notify("No callback available for the selected mode.", vim.log.levels.ERROR)
        return
      end

      callback(choice.method)
    end
  end)
end

M.picker_items = M.generate_picker_items({
  "to_snake_case",
  "to_dash_case",
  "to_camel_case",
  "to_pascal_case",
  "to_constant_case",

  "to_upper_case",
  "to_lower_case",
  "to_title_case",
  "to_dot_case",
})

return M.plugin
