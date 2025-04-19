local schemastore_ok, schemastore = pcall(require, "schemastore")
if not schemastore_ok then
  vim.notify("schemastore plugin not found, cannot apply schemas.", vim.log.levels.WARN)
  schemastore = nil
end

local server_configs = {}

local schema_settings_map = {}
if schemastore then
  schema_settings_map = {
    jsonls = {
      settings = {
        json = { schemas = schemastore.json.schemas(), validate = { enable = true } },
      },
    },
    yamlls = {
      settings = {
        yaml = { schemas = schemastore.yaml.schemas(), schemaStore = { enable = false, url = "" } },
      },
    },
  }
end

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

  local config = config_or_err -- Assign the valid config table

  local schema_settings = schema_settings_map[server_name]
  if schema_settings then
    config.settings = vim.tbl_deep_extend("force", config.settings or {}, schema_settings.settings)
  end

  server_configs[server_name] = config

  ::continue::
end

for name, config in pairs(server_configs) do
  vim.lsp.config(name, config)

  -- If not explicitly disabled
  if config.enabled ~= false then
    vim.lsp.enable(name)
  end
end

