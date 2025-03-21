-- Function to create a prettier display name for the methods
local function get_display_name(method)
  return method:gsub("_", " "):gsub("to ", ""):gsub("case", ""):gsub("^%l", string.upper):gsub("%s+$", "")
end

-- Function to generate items for the picker
local function generate_items(methods)
  local items = {}
  for _, method in ipairs(methods) do
    table.insert(items, {
      text = get_display_name(method),
      method = method, -- Store the method for later use
    })
  end
  return items
end

-- Function to show the picker and handle the selection
local function show_picker(items, title, callback)
  vim.ui.select(items, {
    prompt = title,
    format_item = function(item)
      return item.text
    end,
  }, function(choice)
    if choice then
      callback(choice.method)
    end
  end)
end

local picker_items = generate_items({
  "to_upper_case",
  "to_lower_case",
  "to_snake_case",
  "to_dash_case",
  "to_camel_case",
  "to_pascal_case",
  "to_title_case",
})

return {
  "johmsalas/text-case.nvim",
  lazy = false,
  opts = {
    prefix = "<leader>C",
    substitude_command_name = "TextCaseReplace",
    -- enabled_methods = enabled_methods,
  },
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
  cmd = { "TextCaseReplace" },
}
