local usercmd = vim.api.nvim_create_user_command
local utils = require("r4zen.utils")
local lsp_configs_util = require("r4zen.lsp_utils")

usercmd("LspInfo", function()
  vim.cmd("checkhealth vim.lsp")
end, { desc = "Show lsp info" })

usercmd("LspStop", function()
  local servers = lsp_configs_util.get_servers()
  local stopped_clients_count = 0
  local stopped_client_names = {}

  if not servers then
    vim.notify("LSP server configurations could not be loaded.", vim.log.levels.ERROR)
    return
  end

  for _, server_name in pairs(servers) do
    local clients = vim.lsp.get_clients({ name = server_name })
    for _, client in ipairs(clients) do
      local stop_ok, stop_err = pcall(vim.lsp.stop_client, client.id)
      if stop_ok then
        stopped_clients_count = stopped_clients_count + 1
        stopped_client_names[client.name] = true
      else
        vim.notify(
          "Error stopping client: " .. client.name .. " (ID: " .. client.id .. "): " .. tostring(stop_err),
          vim.log.levels.WARN
        )
      end
    end
  end

  if stopped_clients_count > 0 then
    local names_list = {}
    for name, _ in pairs(stopped_client_names) do
      table.insert(names_list, name)
    end
    vim.notify(
      "Stopped " .. stopped_clients_count .. " LSP client(s): " .. table.concat(names_list, ", "),
      vim.log.levels.INFO
    )
  else
    vim.notify("No running LSP clients found matching configured servers.", vim.log.levels.INFO)
  end
end, {
  desc = "Stop all running LSP clients matching configured servers",
  nargs = 0,
})

-- Command to print open buffers and their filenames
usercmd("ShowBufs", function()
  local bufs = {}
  local bufnums = vim.api.nvim_list_bufs()
  for _, bufnum in ipairs(bufnums) do
    local bufname = vim.api.nvim_buf_get_name(bufnum)
    -- if vim.api.nvim_buf_is_loaded(bufnum) and bufname ~= "" and vim.bo[bufnum].buftype ~= "nofile" then
    if vim.api.nvim_buf_is_loaded(bufnum) and bufname ~= "" and utils.file_exists(bufname) then
      local home = os.getenv("HOME")
      if not home or bufname:sub(1, #home) == home then
        bufs[bufnum] = bufname
      end
    end
  end

  vim.schedule(function()
    local lines = {}
    for bufnum, bufname in pairs(bufs) do
      table.insert(lines, string.format("%d: %s", bufnum, bufname))
    end
    local message = table.concat(lines, "\n")
    vim.notify("Loaded file buffers:\n" .. message, vim.log.levels.INFO)
  end)
end, { desc = "Show open buffers" })
