local function normalizeTable(t)
  local newTable = {}
  for _, v in pairs(t) do
    table.insert(newTable, v)
  end
  return newTable
end

local function get_file_name(path)
  return path:match("([^/\\]+)$")
end

local theme = {
  fill = "TabLineFill",
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = "TabLine",
  current_tab = "TabLineSel",
  tab = "TabLine",
  win = "TabLine",
  tail = "TabLine",
}

return {
  "nanozuki/tabby.nvim",
  -- event = 'VimEnter', -- if you want lazy load, see below
  dependencies = { "nvim-tree/nvim-web-devicons", "ThePrimeagen/harpoon" },
  config = function()
    local tabby = require("tabby")

    tabby.setup({
      line = function(line)
        local marks = normalizeTable(require("harpoon"):list().items)

        local tabs = {}

        local bufpath = vim.fn.expand("%")
        for index, mark in ipairs(marks) do
          local is_current = bufpath:find(mark.value, 1, true)
          local hl = is_current and theme.current_tab or theme.tab

          table.insert(tabs, {
            line.sep("", hl, theme.fill),
            is_current and "" or "󰆣",
            index,
            get_file_name(mark.value),
            line.sep("", hl, theme.fill),
            hl = hl,
            margin = " ",
          })
        end

        return {
          {
            { "  ", hl = theme.head },
            line.sep("", theme.head, theme.fill),
          },
          tabs,
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            return {
              line.sep("", theme.win, theme.fill),
              win.is_current() and "" or "",
              win.buf_name(),
              line.sep("", theme.win, theme.fill),
              hl = theme.win,
              margin = " ",
            }
          end),
          {
            line.sep("", theme.tail, theme.fill),
            { "  ", hl = theme.tail },
          },
          hl = theme.fill,
        }
      end,
      -- option = {}, -- setup modules' option,
    })

    require("harpoon"):extend({
      ADD = function()
        tabby.update()
      end,
      REMOVE = function()
        tabby.update()
      end,
      LIST_CHANGE = function()
        tabby.update()
      end,
    })
  end,
}
