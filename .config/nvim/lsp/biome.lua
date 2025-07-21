local util = require("r4zen.lsp_utils")
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

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

    local lsp_utils = require("r4zen.lsp_utils")
    local biome_executable = client.config.cmd[1]

    map("n", "<leader>cI", lsp_utils.lsp_action["source.organizeImports.biome"], { desc = "Biome: Organize imports" })

    -- autocmd("BufWritePre", {
    --   buffer = bufnr,
    --   callback = function()
    --     if not vim.g.disable_autoformat then
    --       lsp_utils.lsp_action["source.organizeImports.biome"]()
    --     end
    --   end,
    -- })

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
