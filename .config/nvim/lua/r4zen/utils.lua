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

M.lazy_require = function(require_path)
  return setmetatable({}, {
    __index = function(_, key)
      return require(require_path)[key]
    end,

    __newindex = function(_, key, value)
      require(require_path)[key] = value
    end,
  })
end

---@param arg string
M.check_arg = function(arg)
  -- local args = vim.fn.argv()
  local cmd = vim.v.argv

  local found = false
  for _, a in ipairs(cmd) do
    if a == arg then
      found = true
      break
    end
  end

  return found
end

M.includes = function(tbl, val)
  for _, v in ipairs(tbl) do
    if v == val then
      return true
    end
  end
  return false
end

---@param str string
---@param start string
M.startswith = function(str, start)
  return str:sub(1, #start) == start
end

M.file_exists = function(path)
  local f = io.open(path, "r")
  if f then
    f:close()
    return true
  else
    return false
  end
end

M.create_input_cmd_visual_callback = function(cmd)
  return function()
    local mode = vim.api.nvim_get_mode().mode
    local start_line, end_line

    if mode == "v" or mode == "V" then
      start_line = vim.fn.line("'<")
      end_line = vim.fn.line("'>")
    end

    vim.ui.input({ prompt = cmd .. " : " }, function(input)
      if not input or input == "" then
        return
      end

      if start_line and end_line then
        vim.cmd(string.format("%d,%d%s %s", start_line, end_line, cmd, input))
      else
        vim.cmd(cmd .. " " .. input)
      end
    end)
  end
end

M.js_filetypes = {
  "javascript",
  "javascriptreact",
  "javascript.jsx",
  "typescript",
  "typescriptreact",
  "typescript.tsx",
}

return M
