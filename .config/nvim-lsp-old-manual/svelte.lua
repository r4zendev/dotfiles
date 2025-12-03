local function migrate_to_svelte_5()
  local clients = vim.lsp.get_clients({
    bufnr = 0,
    name = "svelte",
  })
  for _, client in ipairs(clients) do
    client:exec_cmd({
      command = "migrate_to_svelte_5",
      arguments = { vim.uri_from_bufnr(0) },
    })
  end
end

return {
  cmd = { "svelteserver", "--stdio" },
  filetypes = { "svelte" },
  root_markers = { "package.json", ".git" },
  on_attach = function(client, bufnr)
    require("r4zen.lsp_utils").on_attach(client, bufnr)

    vim.api.nvim_buf_create_user_command(
      0,
      "MigrateToSvelte5",
      migrate_to_svelte_5,
      { desc = "Migrate Component to Svelte 5 Syntax" }
    )

    -- TODO: Not sure if needed anymore
    -- vim.api.nvim_create_autocmd("BufWritePost", {
    --   pattern = { "*.js", "*.ts" },
    --   callback = function(ctx)
    --     if client.name == "svelte" then
    --       client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
    --     end
    --   end,
    -- })
  end,
}
