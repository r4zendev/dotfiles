local utils = require("r4zen.utils")

local lualine_require = require("lualine_require")
local highlight = require("lualine.highlight")
local M = lualine_require.require("lualine.component"):extend()

local default_options = {
  icon = "󰀱 ",
  _separator = " ",
  no_harpoon = "Harpoon not loaded",
  color_active = nil,
}

function M:init(options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)

  if self.options.color_active then
    self.color_active_hl =
      highlight.create_component_highlight_group(self.options.color_active, "harpoon_active", self.options)
  end
end

function M:update_status()
  local harpoon_loaded = package.loaded["harpoon"] ~= nil
  if not harpoon_loaded then
    return self.options.no_harpoon
  end

  local harpoon = require("harpoon")

  local root_dir = harpoon:list().config:get_root_dir()
  local current_file_path = vim.api.nvim_buf_get_name(0)

  local harpoon_items = harpoon:list().items

  local length = #harpoon_items

  local status = {}

  for i = 1, length do
    local harpoon_item = harpoon_items[i]
    if not harpoon_item then
      return
    end
    local harpoon_path = harpoon_item.value

    local full_path = nil
    if vim.uv.fs_realpath(harpoon_path) == nil then
      full_path = vim.fs.joinpath(root_dir, harpoon_path)
    else
      full_path = harpoon_path
    end

    local active = full_path == current_file_path
    local indicator = i .. " " .. utils.get_fname_parts(full_path)
    if active then
      indicator = "[" .. indicator .. "]"
    end

    local label = indicator
    if type(indicator) == "function" then
      label = indicator(harpoon_item)
    end

    if self.options.color_active and active then
      label = highlight.component_format_highlight(self.color_active_hl) .. label .. self:get_default_hl()
    end

    table.insert(status, label)
  end

  return table.concat(status, self.options._separator)
end

return M
