local bin_name = "marksman"
local cmd = { bin_name, "server" }

return {
  enabled = false,
  cmd = cmd,
  filetypes = { "markdown", "markdown.mdx" },
  root_markers = { ".marksman.toml", ".git" },
}
