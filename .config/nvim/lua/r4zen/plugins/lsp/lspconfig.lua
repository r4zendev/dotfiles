return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "saghen/blink.cmp" },
    { "b0o/schemastore.nvim" },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    local opts = { noremap = true, silent = true }
    local on_attach = function(client, bufnr)
      opts.buffer = bufnr

      opts.desc = "Go to declaration"
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

      opts.desc = "See available code actions"
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

      opts.desc = "Smart rename"
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

      -- opts.desc = "Show line diagnostics"
      -- vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

      -- opts.desc = "Go to previous diagnostic"
      -- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
      --
      -- opts.desc = "Go to next diagnostic"
      -- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

      opts.desc = "Show documentation for what is under cursor"
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

      opts.desc = "Restart LSP"
      vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

      opts.desc = "Organize imports"
      vim.keymap.set("n", "<leader>ci", ":LspOrganizeImports<CR>", opts) -- organize imports
    end

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- configure html server
    lspconfig["html"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    local function organize_imports()
      local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = "",
      }
      vim.lsp.buf.execute_command(params)
    end

    -- configure typescript server with plugin
    lspconfig["ts_ls"].setup({
      capabilities = capabilities,
      commands = {
        LspOrganizeImports = {
          organize_imports,
          description = "Organize Imports",
        },
      },
    })

    lspconfig["jsonls"].setup({
      capabilities = capabilities,
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
      on_attach = on_attach,
    })

    local eslint_alerted = false

    -- Default eslint root files
    -- Taken from https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/eslint.lua
    local eslint_root_file = {
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.yaml",
      ".eslintrc.yml",
      ".eslintrc.json",
      "eslint.config.js",
      "eslint.config.mjs",
      "eslint.config.cjs",
      "eslint.config.ts",
      "eslint.config.mts",
      "eslint.config.cts",
    }

    lspconfig["eslint"].setup({
      -- Makes ESLint work in monorepos (???)
      -- settings = { workingDirectory = { mode = "auto" } },
      -- root_dir = lspconfig.util.find_git_ancestor,

      capabilities = capabilities,

      root_dir = function(fname)
        local ignored_dirs = {
          "/Users/razen/projects/ballerine/oss",
        }

        for _, dir in ipairs(ignored_dirs) do
          if string.find(fname, dir) then
            -- Don't load ESLint for projects where it is broken
            return nil
          end
        end

        -- Default lspconfig root_dir function
        -- Taken from https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/eslint.lua
        local util = require("lspconfig.util")
        eslint_root_file = util.insert_package_json(eslint_root_file, "eslintConfig", fname)
        return util.root_pattern(eslint_root_file)(fname)
      end,

      handlers = {
        ["textDocument/diagnostic"] = function(...)
          local data, _, evt, _ = ...

          if data and data.code and data.code < 0 then
            if not eslint_alerted then
              vim.notify(
                string.format("ESLint failed due to an error: \n%s", data.message),
                vim.log.levels.WARN,
                { title = "ESLint" }
              )
              eslint_alerted = true
            end

            return
          end

          return vim.lsp.diagnostic.on_diagnostic(...)
        end,
      },

      on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Auto-format with LSP
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            if not vim.g.disable_autoformat then
              vim.cmd("EslintFixAll")
            end
          end,
        })

        vim.keymap.set("n", "<leader>ce", ":EslintFixAll<CR>", {
          desc = "Fix all ESLint issues",
          buffer = bufnr,
        })
      end,
    })

    -- Auto-formatting is handled in conform using lsp_fallback flag
    lspconfig["biome"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["cssls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["tailwindcss"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["svelte"].setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            if client.name == "svelte" then
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
            end
          end,
        })
      end,
    })

    lspconfig["prismals"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["graphql"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    lspconfig["pyright"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Using instead of vim's native spell check
    lspconfig["typos_lsp"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      cmd_env = { RUST_LOG = "error" },
      init_options = {
        -- Equivalent to the typos `--config` cli argument.
        config = "~/.config/nvim/_typos.toml",
        -- How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
        diagnosticSeverity = "Hint",
      },
    })

    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })
  end,
}
