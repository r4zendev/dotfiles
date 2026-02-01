local M = {}

M.workspace_root = function()
  return vim.fs.root(0, { ".git" }) or vim.uv.cwd()
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

return M
