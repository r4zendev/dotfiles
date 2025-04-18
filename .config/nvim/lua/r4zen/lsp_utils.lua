local map = vim.keymap.set

local M = {}
local iswin = vim.uv.os_uname().version:match("Windows")

M.on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  local opts = function(desc)
    return { desc = desc, noremap = true, silent = true, buffer = bufnr }
  end

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("See available code actions"))
  map("n", "<leader>cn", vim.lsp.buf.rename, opts("Smart rename"))
  map("n", "<leader>cr", function()
    for _, buf_client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
      for buf_id, _ in pairs(buf_client.attached_buffers) do
        vim.lsp.buf_detach_client(buf_id, buf_client.id)
        vim.defer_fn(function()
          vim.lsp.buf_attach_client(buf_id, buf_client.id)
        end, 500)
      end
    end
  end, opts("Restart LSP"))
  map({ "n", "v" }, "<leader>cq", function()
    vim.diagnostic.setqflist({ open = false })

    -- require("quicker").toggle()
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
      vim.cmd("silent! checktime")
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

local function escape_wildcards(path)
  return path:gsub("([%[%]%?%*])", "\\%1")
end

function M.root_pattern(...)
  local patterns = M.tbl_flatten({ ... })
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
