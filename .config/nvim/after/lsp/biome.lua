---@brief
--- https://biomejs.dev
---
--- Toolchain of the web. [Successor of Rome](https://biomejs.dev/blog/annoucing-biome).
---
--- ```sh
--- npm install [-g] @biomejs/biome
--- ```
---
--- ### Monorepo support
---
--- `biome` supports monorepos by default. It will automatically find the `biome.json` corresponding to the package you are working on, as described in the [documentation](https://biomejs.dev/guides/big-projects/#monorepo). This works without the need of spawning multiple instances of `biome`, saving memory.

local util = require("r4zen.lsp_utils")
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

return {
  on_attach = function(client, bufnr)
    util.on_attach(client, bufnr)

    autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        if not vim.g.disable_autoformat then
          util.lsp_action["source.fixAll.biome"]()
        end
      end,
    })

    map("n", "<leader>cI", util.lsp_action["source.organizeImports.biome"], {
      desc = "Biome: Organize Imports",
      buffer = bufnr,
    })

    local biome_executable = "biome"
    local local_cmd = (client.config or {}).root_dir and client.config.root_dir .. "/node_modules/.bin/biome"
    if local_cmd and vim.fn.executable(local_cmd) == 1 then
      biome_executable = local_cmd
    end

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
