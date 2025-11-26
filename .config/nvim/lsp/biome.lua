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
  cmd = function(dispatchers, config)
    local cmd = "biome"
    local local_cmd = (config or {}).root_dir and config.root_dir .. "/node_modules/.bin/biome"
    if local_cmd and vim.fn.executable(local_cmd) == 1 then
      cmd = local_cmd
    end
    return vim.lsp.rpc.start({ cmd, "lsp-proxy" }, dispatchers)
  end,
  filetypes = {
    "astro",
    "css",
    "graphql",
    "html",
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
  root_dir = function(bufnr, on_dir)
    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }

    root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
      or vim.list_extend(root_markers, { ".git" })

    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

    local filename = vim.api.nvim_buf_get_name(bufnr)
    local biome_config_files = { "biome.json", "biome.jsonc" }
    biome_config_files = util.insert_package_json(biome_config_files, "biome", filename)
    local is_buffer_using_biome = vim.fs.find(biome_config_files, {
      path = filename,
      type = "file",
      limit = 1,
      upward = true,
      stop = vim.fs.dirname(project_root),
    })[1]
    if not is_buffer_using_biome then
      return
    end

    on_dir(project_root)
  end,
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
