local M = {}

M.get_fname_parts = function(path)
  local filename = vim.fs.basename(path)
  local name, extension = filename:match("^(.*)%.([^.]*)$")

  if not name then
    return filename, ""
  end

  return name, "." .. extension
end

M.get_hl = function(name)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
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

M.workspace_root = function()
  return vim.fs.root(0, { ".git" }) or vim.uv.cwd()
end

return M
