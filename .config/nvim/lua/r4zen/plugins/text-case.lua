local function format_method_name(method)
  return method:gsub("_", " "):gsub("to ", ""):gsub("case", ""):gsub("^%l", string.upper):gsub("%s+$", "")
end

local function generate_picker_items(methods)
  local items = {}
  for _, method in ipairs(methods) do
    table.insert(items, { text = format_method_name(method), method = method })
  end
  return items
end

local function show_picker(items, title, callback)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  vim.ui.select(items, {
    prompt = title,
    format_item = function(item)
      return item.text
    end,
  }, function(choice)
    if choice then
      vim.api.nvim_win_set_cursor(0, cursor_pos)
      callback(choice.method)
    end
  end)
end

local picker_items = generate_picker_items({
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

return {
  "johmsalas/text-case.nvim",
  event = { "BufRead", "BufNewFile" },
  opts = { prefix = "<leader>C" },
  keys = {
    {
      "<leader>Ct",
      function()
        show_picker(picker_items, "Text Case: Rename Word", require("textcase").current_word)
      end,
      desc = "TextCase: Rename current word",
      mode = { "n", "v" },
    },
    {
      "<leader>CT",
      function()
        show_picker(picker_items, "Text Case: LSP Rename", require("textcase").lsp_rename)
      end,
      desc = "TextCase: LSP Rename",
      mode = { "n", "v" },
    },
  },
}
