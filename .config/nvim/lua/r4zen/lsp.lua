local schemastore_ok, schemastore = pcall(require, "schemastore")
if not schemastore_ok then
  vim.notify("schemastore plugin not found, cannot apply schemas.", vim.log.levels.WARN)
  schemastore = nil
end

local server_configs = require("r4zen.lsp_utils").get_servers_with_configs()

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

for _, server_name in ipairs({ "jsonls", "yamlls" }) do
  if server_configs[server_name] and schema_settings_map[server_name] then
    server_configs[server_name].settings = vim.tbl_deep_extend(
      "force",
      server_configs[server_name].settings or {},
      schema_settings_map[server_name].settings
    )
  end
end

for name, config in pairs(server_configs) do
  vim.lsp.config(name, config)

  -- If not explicitly disabled
  if config.enabled ~= false then
    vim.lsp.enable(name)
  end
end
