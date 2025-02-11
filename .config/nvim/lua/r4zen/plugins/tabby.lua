local function normalize_table(t)
  local newTable = {}
  for _, v in pairs(t) do
    table.insert(newTable, v)
  end
  return newTable
end

local function get_file_name(path)
  local filename, extension = path:match("([^/\\]+)%.([^/\\]+)$")
  if not filename then
    -- If no extension is found, just return the full filename without any modification
    filename = path:match("([^/\\]+)$")
    extension = "" -- No extension for files without one
  else
    -- For files with extensions, include the dot in the extension
    extension = "." .. extension
  end
  return filename or "", extension or ""
end

local find_buffer_by_name = function(name)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name == name then
      return buf
    end
  end

  return -1
end

local function get_hl(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })

  if not ok then
    return
  end

  for _, key in pairs({ "fg", "bg", "special" }) do
    if hl[key] then
      hl[key] = string.format("#%06x", hl[key])
    end
  end

  return hl
end

local theme = {
  fill = "TabLineFill",
  head = "TabLine",
  current_tab = "TabLineSel",
  external_tab = { fg = "#f2e9de", bg = "#907aa9", style = "italic" },
  tab = "TabLine",
  win = "TabLine",
  tail = "TabLine",
}

return {
  "nanozuki/tabby.nvim",
  -- event = 'VimEnter', -- if you want lazy load, see below
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "ThePrimeagen/harpoon",
  },
  config = function()
    local tabby = require("tabby")
    local harpoon = require("harpoon")

    tabby.setup({
      line = function(line)
        local marks = normalize_table(harpoon:list().items)

        local current_buf_path = vim.fn.expand("%")

        local tabs = {}
        local is_in_marks = false

        for index, mark in ipairs(marks) do
          local is_current = current_buf_path:find(mark.value, 1, true)
          local buf = find_buffer_by_name(vim.fn.getcwd() .. "/" .. mark.value)
          local buf_modified = buf > -1
              and vim.api.nvim_get_option_value("modified", {
                buf = buf,
              })
            or false

          local hl = is_current and theme.current_tab or theme.tab

          local mark_buf_fn, mark_buf_ext = get_file_name(mark.value)

          if is_current then
            is_in_marks = true
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(mark_buf_ext)
          local bg_color = get_hl(hl).bg
          print(bg_color)

          table.insert(tabs, {
            line.sep("", hl, theme.fill),
            -- is_current and "" or "󰆣",
            -- { line.api.get_icon(mark_buf_ext), hl = hl },
            { icon, hl = { fg = color, bg = bg_color } },
            index,
            mark_buf_fn .. mark_buf_ext,
            buf_modified and "",
            line.sep("", hl, theme.fill),
            hl = hl,
            margin = " ",
          })
        end

        -- Unpinned tab
        if
          not is_in_marks
          and current_buf_path
          and not current_buf_path:find("__harpoon-menu__", 1, true)
          and not current_buf_path:find("Grug FAR", 1, true)
        then
          local hl = theme.external_tab -- Use a different theme style for unmarked tabs

          local unpinned_buf_fn, unpinned_buf_ext = get_file_name(current_buf_path)

          table.insert(tabs, {
            line.sep("", hl, theme.fill),
            -- "󰛔", -- Different icon for unmarked files
            line.api.get_icon(unpinned_buf_ext),
            #tabs + 1,
            unpinned_buf_fn .. unpinned_buf_ext,
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
  end,
}
