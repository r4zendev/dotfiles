local M = {}

M.normalize_table = function(t)
  local newTable = {}
  for _, v in pairs(t) do
    table.insert(newTable, v)
  end
  return newTable
end

M.get_file_name = function(path)
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

M.find_buffer_by_name = function(name)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name == name then
      return buf
    end
  end

  return -1
end

M.get_hl = function(name)
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

M.remap = function(mode, lhs_from, lhs_to)
  local keymap = vim.fn.maparg(lhs_from, mode, false, true)
  local rhs = keymap.callback or keymap.rhs
  if rhs == nil then
    error("Could not remap from " .. lhs_from .. " to " .. lhs_to)
  end
  vim.keymap.set(mode, lhs_to, rhs, { desc = keymap.desc })
end

return M
