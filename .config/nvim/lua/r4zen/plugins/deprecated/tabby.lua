local utils = require("r4zen.utils")

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
        local marks = utils.normalize_table(harpoon:list().items)

        local current_buf_path = vim.fn.expand("%")

        local tabs = {}
        local is_in_marks = false

        for index, mark in ipairs(marks) do
          local is_current = current_buf_path:find(mark.value, 1, true)
          local buf = vim.fn.bufnr(vim.fn.getcwd() .. "/" .. mark.value, false)
          local buf_modified = buf > -1
              and vim.api.nvim_get_option_value("modified", {
                buf = buf,
              })
            or false

          local hl = is_current and theme.current_tab or theme.tab

          local mark_buf_fn, mark_buf_ext = utils.get_fname_parts(mark.value)

          if is_current then
            is_in_marks = true
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(mark_buf_ext)
          local bg_color = utils.get_hl(hl).bg

          table.insert(tabs, {
            line.sep("", hl, theme.fill),
            -- is_current and "" or "󰆣",
            -- { line.api.get_icon(mark_buf_ext), hl = hl },
            (is_current or color == bg_color) and icon or { icon, hl = { fg = color, bg = bg_color } },
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

          local unpinned_buf_fn, unpinned_buf_ext = utils.get_fname_parts(current_buf_path)
          if string.len(unpinned_buf_fn) > 0 then
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
