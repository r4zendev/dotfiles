local map = vim.keymap.set

local M = {}

M.plugin = {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "antosha417/nvim-lsp-file-operations",
    "b0o/schemastore.nvim",
  },
  config = function()
    M.servers = vim.tbl_deep_extend("force", M.servers, {
      vtsls = {
        settings = {
          ["js/ts"] = { implicitProjectConfig = { checkJs = true } },
          javascript = vim.deepcopy(M.servers.vtsls.settings.typescript),
        },
      },
      jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      },
    })

    for server, settings in pairs(M.servers) do
      if settings.enabled == false then
        goto continue
      end

      vim.lsp.config(server, vim.tbl_deep_extend("force", { on_attach = M.on_attach }, settings))
      vim.lsp.enable(server)

      ::continue::
    end

    -- NOTE: Below are the servers that were not migrated to the new nvim 0.11 lsp setup

    local lspconfig = require("lspconfig")
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    lspconfig["eslint"].setup({
      -- Makes ESLint work in monorepos (???)
      -- settings = { workingDirectory = { mode = "auto" } },
      -- root_dir = lspconfig.util.find_git_ancestor,

      capabilities = capabilities,

      root_dir = function(fname)
        local ignored_dirs = {
          os.getenv("HOME") .. "/projects/ballerine/oss",
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
        local root_file = util.insert_package_json(M.eslint_root_file, "eslintConfig", fname)
        return util.root_pattern(root_file)(fname)
      end,

      handlers = {
        ["textDocument/diagnostic"] = function(...)
          local data, _, evt, _ = ...

          if data and data.code and data.code < 0 then
            if not M.eslint_alerted then
              vim.notify(
                string.format("ESLint failed due to an error: \n%s", data.message),
                vim.log.levels.WARN,
                { title = "ESLint" }
              )
              M.eslint_alerted = true
            end

            return
          end

          return vim.lsp.diagnostic.on_diagnostic(...)
        end,
      },

      on_attach = function(client, bufnr)
        M.on_attach(client, bufnr)

        -- Auto-format with LSP
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            if not vim.g.disable_autoformat then
              vim.cmd("EslintFixAll")
            end
          end,
        })

        map("n", "<leader>ce", ":EslintFixAll<CR>", {
          desc = "Fix all ESLint issues",
          buffer = bufnr,
        })
      end,
    })

    -- Auto-formatting is handled in conform using lsp_fallback flag
    -- lspconfig["biome"].setup({
    --   capabilities = capabilities,
    --   on_attach = M.on_attach,
    -- })

    lspconfig["tailwindcss"].setup({
      capabilities = capabilities,
      on_attach = M.on_attach,
    })

    lspconfig["astro"].setup({
      capabilities = capabilities,
      on_attach = M.on_attach,
    })
  end,
}

M.lsp_action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

function M.execute_command(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }
  if opts.open then
    require("trouble").open({ mode = "lsp_command", params = params })
  else
    return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
  end
end

M.on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  local opts = function(desc)
    return { desc = desc, noremap = true, silent = true, buffer = bufnr }
  end

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("See available code actions"))
  map("n", "<leader>rn", vim.lsp.buf.rename, opts("Smart rename"))
  map("n", "<leader>rs", vim.cmd.LspRestart, opts("Restart LSP"))
  map({ "n", "v" }, "<leader>cq", function()
    vim.diagnostic.setqflist({ open = false })

    -- require("quicker").toggle()
    require("trouble").open({ mode = "quickfix", focus = false })
  end, opts("Populate qflist with diagnostics"))
end

M.servers = {
  -- TypeScript / JavaScript
  ts_ls = {
    enabled = false,
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)

      map("n", "<leader>ci", M.lsp_action["source.organizeImports"], { buffer = bufnr, desc = "Organize Imports" })
    end,
  },
  vtsls = {
    enabled = true,
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
    },
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)

      local opts = function(desc)
        return { desc = desc, buffer = bufnr, silent = true, noremap = true }
      end

      map("n", "gD", function()
        -- Works without args
        ---@diagnostic disable-next-line: missing-parameter
        local params = vim.lsp.util.make_position_params()
        M.execute_command({
          command = "typescript.goToSourceDefinition",
          arguments = { params.textDocument.uri, params.position },
          open = true,
        })
      end, opts("Goto Source Definition"))

      map("n", "gR", function()
        M.execute_command({
          command = "typescript.findAllFileReferences",
          arguments = { vim.uri_from_bufnr(0) },
          open = true,
        })
      end, opts("File References"))

      map("n", "<leader>ci", M.lsp_action["source.organizeImports"], opts("TS: Organize imports"))
      map("n", "<leader>cM", M.lsp_action["source.addMissingImports.ts"], opts("TS: Add missing imports"))
      map("n", "<leader>cu", M.lsp_action["source.removeUnused.ts"], opts("TS: Remove unused imports"))
      map("n", "<leader>cD", M.lsp_action["source.fixAll.ts"], opts("TS: Fix all diagnostics"))
      map("n", "<leader>cV", function()
        M.execute_command({ command = "typescript.selectTypeScriptVersion" })
      end, opts("TS: Select workspace version"))

      client.commands["_typescript.moveToFileRefactoring"] = function(command)
        ---@type string, string, lsp.Range
        local action, uri, range = unpack(command.arguments)

        local function move(newf)
          client.request("workspace/executeCommand", {
            command = command.command,
            arguments = { action, uri, range, newf },
          })
        end

        local fname = vim.uri_to_fname(uri)
        client.request("workspace/executeCommand", {
          command = "typescript.tsserverRequest",
          arguments = {
            "getMoveToRefactoringFileSuggestions",
            {
              file = fname,
              startLine = range.start.line + 1,
              startOffset = range.start.character + 1,
              endLine = range["end"].line + 1,
              endOffset = range["end"].character + 1,
            },
          },
        }, function(_, result)
          ---@type string[]
          local files = result.body.files
          table.insert(files, 1, "Enter new path...")
          vim.ui.select(files, {
            prompt = "Select move destination:",
            format_item = function(f)
              return vim.fn.fnamemodify(f, ":~:.")
            end,
          }, function(f)
            if f and f:find("^Enter new path") then
              vim.ui.input({
                prompt = "Enter move destination:",
                default = vim.fn.fnamemodify(fname, ":h") .. "/",
                completion = "file",
              }, function(newf)
                return newf and move(newf)
              end)
            elseif f then
              move(f)
            end
          end)
        end)
      end
    end,
  },
  svelte = {
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)

      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.js", "*.ts" },
        callback = function(ctx)
          if client.name == "svelte" then
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
          end
        end,
      })
    end,
  },
  biome = {},
  cssls = {},
  prismals = { filetypes = { "prisma" } },

  -- Rust
  rust_analyzer = {
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)

      map("n", "<leader>ca", function()
        vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
        -- or vim.lsp.buf.codeAction() if you don't want grouping.
      end, { silent = true, buffer = bufnr })

      -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
      map("n", "K", function()
        vim.cmd.RustLsp({ "hover", "actions" })
      end, { silent = true, buffer = bufnr })
    end,
  },

  -- Lua
  lua_ls = {
    settings = {
      Lua = {
        telemetry = { enable = false },
        -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        diagnostics = { disable = { "missing-fields" } },
        hint = { enable = true },
      },
    },
  },

  -- Markdown
  marksman = {},

  -- Python
  pyright = {},

  -- Spell check
  typos_lsp = {
    cmd_env = { RUST_LOG = "error" },
    init_options = {
      -- Equivalent to the typos `--config` cli argument.
      config = "~/.config/nvim/_typos.toml",
      -- How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
      diagnosticSeverity = "Hint",
    },
  },
  -- harper_ls = {
  --   settings = {
  --     ["harper-ls"] = {
  --       userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
  --     },
  --   },
  -- },
}

M.eslint_alerted = false

M.eslint_root_file = {
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

return M.plugin
