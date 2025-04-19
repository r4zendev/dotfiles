local function get_typescript_server_path(root_dir)
  local project_root = vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])
  return project_root and vim.fs.joinpath(project_root, "node_modules", "typescript", "lib") or ""
end

-- https://github.com/vuejs/language-tools/blob/master/packages/language-server/lib/types.ts
local volar_init_options = {
  typescript = {
    tsdk = "",
  },
}

return {
  enabled = false,
  cmd = { "vue-language-server", "--stdio" },
  filetypes = { "vue" },
  root_markers = { "package.json" },
  init_options = volar_init_options,
  before_init = function(_, config)
    if config.init_options and config.init_options.typescript and config.init_options.typescript.tsdk == "" then
      config.init_options.typescript.tsdk = get_typescript_server_path(config.root_dir)
    end
  end,
}
