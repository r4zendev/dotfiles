local function normalizeTable(t)
  local newTable = {}
  for _, v in pairs(t) do
    table.insert(newTable, v)
  end
  return newTable
end

return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "ThePrimeagen/harpoon" },
  version = "*",
  config = function()
    local bufferline = require("bufferline")

    bufferline.setup({
      options = {
        numbers = function(number_opts)
          local marks = normalizeTable(require("harpoon"):list().items)

          for index, item in ipairs(marks) do
            if vim.fn.bufname(number_opts.id):find(item.value, 1, true) then
              return index
            end
          end
        end,
        custom_filter = function(buf_number, buf_numbers)
          local marks = normalizeTable(require("harpoon"):list().items)

          if buf_number == buf_numbers[#buf_numbers] and buf_number == vim.api.nvim_get_current_buf() then
            return true
          end

          for _, item in ipairs(marks) do
            if vim.fn.bufname(buf_number):find(item.value, 1, true) then
              return true
            end
          end

          return false
        end,
        sort_by = function(buffer_a, buffer_b)
          local marks = normalizeTable(require("harpoon"):list().items)

          local a = 1
          local b = 1

          for _, item in ipairs(marks) do
            if vim.fn.bufname(buffer_a.id):find(item.value, 1, true) then
              a = 0
              break
            elseif vim.fn.bufname(buffer_b.id):find(item.value, 1, true) then
              b = 0
              break
            end
          end

          return a < b
        end,
        close_command = function(bufnum)
          local harpoon = require("harpoon")
          local marks = normalizeTable(harpoon:list().items)

          for _, item in ipairs(marks) do
            if vim.fn.bufname(bufnum):find(item.value, 1, true) then
              harpoon:list():remove(item)
              break
            end
          end
        end,
      },
    })

    local harpoon = require("harpoon")
    harpoon:extend({
      ADD = bufferline.sort_by,
      REMOVE = bufferline.sort_by,
      -- REPLACE =
      -- ADD = function() end,
      -- REMOVE = function(props)
      --   props.list = normalizeTable(props.list)
      --   -- { list = self, item = item, idx = i }
      -- end,
      -- REPLACE =
      -- SELECT = "SELECT",
      -- POSITION_UPDATED = "POSITION_UPDATED",
    })
  end,
}
