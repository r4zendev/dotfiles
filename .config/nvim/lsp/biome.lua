local util = require("r4zen.lsp_utils")
local map = vim.keymap.set

return {
  cmd = { "biome", "lsp-proxy" },
  filetypes = {
    "astro",
    "css",
    "graphql",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "svelte",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
    "vue",
  },
  workspace_required = true,
  root_markers = { "biome.json", "biome.jsonc" },
  on_attach = function(client, bufnr)
    util.on_attach(client, bufnr)

    local biome_executable = client.config.cmd[1]

    map("n", "<leader>cl", function()
      local cmd = { biome_executable, "check", vim.api.nvim_buf_get_name(bufnr), "--fix", "--unsafe" }
      util.execute_system_cmd_and_sync_buf(cmd)
    end, { buffer = bufnr, desc = "Biome: Fix Unsafe" })

    map("n", "<leader>cL", function()
      local cmd = { biome_executable, "check", ".", "--fix", "--unsafe" }
      util.execute_system_cmd_and_sync_buf(cmd)
    end, { buffer = bufnr, desc = "Biome: Fix Unsafe (Workspace)" })
  end,
}
