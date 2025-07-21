local map = vim.keymap.set

local M = {}
local iswin = vim.uv.os_uname().version:match("Windows")

M.get_servers =function ()
  local server_configs = {}
  for _, filepath in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
    local server_name = vim.fn.fnamemodify(filepath, ":t:r")
    if server_name ~= "utils" then
      server_configs[#server_configs + 1] = server_name
    end
  end
  return server_configs
end

M.get_servers_with_configs = function()
  local server_configs = {}

  for _, filepath in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
    local server_name = vim.fn.fnamemodify(filepath, ":t:r")

    if server_name == "utils" then
      goto continue
    end

    local chunk, load_err = loadfile(filepath)
    if not chunk then
      vim.notify(
        string.format("Failed to load LSP config file: %s\nError: %s", filepath, load_err or "Unknown error"),
        vim.log.levels.ERROR
      )
      goto continue
    end

    local exec_ok, config_or_err = pcall(chunk)
    if not exec_ok then
      vim.notify(
        string.format("Failed to execute LSP config file: %s\nError: %s", filepath, tostring(config_or_err)),
        vim.log.levels.ERROR
      )
      goto continue
    end

    if type(config_or_err) ~= "table" then
      vim.notify(string.format("LSP config file did not return a table: %s", filepath), vim.log.levels.WARN)
      goto continue
    end

    server_configs[server_name] = config_or_err

    ::continue::
  end

  return server_configs
end

M.on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  local opts = function(desc)
    return { desc = desc, noremap = true, silent = true, buffer = bufnr }
  end

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("See available code actions"))
  map("n", "<leader>cn", vim.lsp.buf.rename, opts("Smart rename"))
  map("n", "<leader>cd", function()
    vim.diagnostic.open_float()
    vim.diagnostic.open_float()
  end, opts("Go inside diagnostic window"))
  map({ "n", "v" }, "<leader>cq", function()
    vim.diagnostic.setqflist({ open = false })
    require("trouble").open({ mode = "quickfix", focus = false })
  end, opts("Populate qflist with diagnostics"))
end

---@param client vim.lsp.Client
M.toggle_ts_server = function(client)
  local new_server_name = client.name == "vtsls" and "ts_ls" or "vtsls"
  vim.lsp.enable("vtsls", new_server_name == "vtsls")
  vim.lsp.enable("ts_ls", new_server_name == "ts_ls")

  for buf_id, _ in pairs(client.attached_buffers) do
    vim.lsp.buf_detach_client(buf_id, client.id)
    vim.b[buf_id].navic_client_id = nil
  end

  vim.cmd("silent! e")

  vim.defer_fn(function()
    local new_server_id = vim.lsp.get_clients({ name = new_server_name })[1].id
    for buf_id, _ in pairs(client.attached_buffers) do
      vim.lsp.buf_attach_client(buf_id, new_server_id)
    end
  end, 1000)
end

M.lsp_action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

function M.execute_command(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }

  if opts.open then
    return require("trouble").open({ mode = "lsp_command", params = params })
  end

  return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
end

M.execute_system_cmd_and_sync_buf = function(cmd)
  vim.system(cmd, { detach = true }, function(obj)
    vim.notify(obj.stdout, vim.log.levels.INFO)
    vim.schedule(function()
      -- vim.cmd("silent! checktime")
      vim.cmd("silent! e!")
    end)
  end)
end

-- NOTE: Below are functions that I need in my lsp setup copied from `lspconfig.util`
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/util.lua

function M.insert_package_json(config_files, field, fname)
  local path = vim.fn.fnamemodify(fname, ":h")
  local root_with_package = vim.fs.dirname(vim.fs.find("package.json", { path = path, upward = true })[1])

  if root_with_package then
    -- only add package.json if it contains field parameter
    local path_sep = iswin and "\\" or "/"
    for line in io.lines(root_with_package .. path_sep .. "package.json") do
      if line:find(field) then
        config_files[#config_files + 1] = "package.json"
        break
      end
    end
  end
  return config_files
end

M.validate_bufnr = function(bufnr)
  vim.validate("bufnr", bufnr, "number")
  return bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
end

local function is_fs_root(path)
  if iswin then
    return path:match("^%a:$")
  else
    return path == "/"
  end
end

-- Traverse the path calling cb along the way.
local function traverse_parents(path, cb)
  path = vim.loop.fs_realpath(path)
  local dir = path
  -- Just in case our algo is buggy, don't infinite loop.
  for _ = 1, 100 do
    dir = vim.fs.dirname(dir)
    if not dir then
      return
    end
    -- If we can't ascend further, then stop looking.
    if cb(dir, path) then
      return dir, path
    end
    if is_fs_root(dir) then
      break
    end
  end
end

M.is_descendant = function(root, path)
  if not path then
    return false
  end

  local function cb(dir, _)
    return dir == root
  end

  local dir, _ = traverse_parents(path, cb)

  return dir == root
end

function M.search_ancestors(startpath, func)
  vim.validate("func", func, "function")
  if func(startpath) then
    return startpath
  end
  local guard = 100
  for path in vim.fs.parents(startpath) do
    -- Prevent infinite recursion if our algorithm breaks
    guard = guard - 1
    if guard == 0 then
      return
    end

    if func(path) then
      return path
    end
  end
end

local function escape_wildcards(path)
  return path:gsub("([%[%]%?%*])", "\\%1")
end

function M.strip_archive_subpath(path)
  -- Matches regex from zip.vim / tar.vim
  path = vim.fn.substitute(path, "zipfile://\\(.\\{-}\\)::[^\\\\].*$", "\\1", "")
  path = vim.fn.substitute(path, "tarfile:\\(.\\{-}\\)::.*$", "\\1", "")
  return path
end

function M.root_pattern(...)
  local patterns = vim.iter({ ... }):flatten():totable()
  return function(startpath)
    startpath = M.strip_archive_subpath(startpath)
    for _, pattern in ipairs(patterns) do
      local match = M.search_ancestors(startpath, function(path)
        for _, p in ipairs(vim.fn.glob(table.concat({ escape_wildcards(path), pattern }, "/"), true, true)) do
          if vim.loop.fs_stat(p) then
            return path
          end
        end
      end)

      if match ~= nil then
        return match
      end
    end
  end
end

return M
