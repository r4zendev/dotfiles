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

local servers = {
  marksman = {},
  rust_analyzer = {},
  vtsls = {
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
      javascript = {
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
  },

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

  pyright = {},

  jsonls = {},
  yamlls = {},

  biome = {},
  cssls = {},
  tailwindcss = {},

  svelte = {},

  prismals = {
    filetypes = { "prisma" },
  },

  graphql = {
    filetypes = { "graphql", "gql" },
  },

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

  eslint = {
    -- Makes ESLint work in monorepos (???)
    -- settings = { workingDirectory = { mode = "auto" } },
    -- root_dir = function(fname)
    --   return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
    -- end,

    -- root_dir = function(fname)
    --   local ignored_dirs = {
    --     os.getenv("HOME") .. "/projects/ballerine/oss",
    --   }
    --
    --   for _, dir in ipairs(ignored_dirs) do
    --     if string.find(fname, dir) then
    --       -- Don't load ESLint for projects where it is broken
    --       return nil
    --     end
    --   end
    --
    --   -- Default lspconfig root_dir function
    --   -- Taken from https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/eslint.lua
    --   local util = require("lspconfig.util")
    --   eslint_root_file = util.insert_package_json(eslint_root_file, "eslintConfig", fname)
    --   return util.root_pattern(eslint_root_file)(fname)
    -- end,

    -- handlers = {
    --   ["textDocument/diagnostic"] = function(...)
    --     local data, _, evt, _ = ...
    --
    --     if data and data.code and data.code < 0 then
    --       if not eslint_alerted then
    --         vim.notify(
    --           string.format("ESLint failed due to an error: \n%s", data.message),
    --           vim.log.levels.WARN,
    --           { title = "ESLint" }
    --         )
    --         eslint_alerted = true
    --       end
    --
    --       return
    --     end
    --
    --     return vim.lsp.diagnostic.on_diagnostic(...)
    --   end,
    -- },
  },
}

return {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "antosha417/nvim-lsp-file-operations",
    "b0o/schemastore.nvim",
  },
  config = function()
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    local on_attach = function(client, bufnr)
      if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
      end

      opts.buffer = bufnr

      opts.desc = "See available code actions"
      map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

      opts.desc = "Populate qflist with diagnostics"
      map({ "n", "v" }, "<leader>cq", function()
        vim.diagnostic.setqflist({ open = false })

        -- require("quicker").toggle()
        require("trouble").open({ mode = "quickfix", focus = false })
      end, opts)

      opts.desc = "Smart rename"
      map("n", "<leader>rn", vim.lsp.buf.rename, opts)

      opts.desc = "Restart LSP"
      map("n", "<leader>rs", ":LspRestart<CR>", opts)
    end

    -- Special formatted fields cannot be set above
    servers.vtsls.settings["js/ts"] = { implicitProjectConfig = { checkJs = true } }

    -- servers.eslint.on_attach = function(client, bufnr)
    --   on_attach(client, bufnr)
    --
    --   -- Auto-format with LSP
    --   vim.api.nvim_create_autocmd("BufWritePre", {
    --     buffer = bufnr,
    --     callback = function()
    --       if not vim.g.disable_autoformat then
    --         vim.cmd("EslintFixAll")
    --       end
    --     end,
    --   })
    --
    --   map("n", "<leader>ce", ":EslintFixAll<CR>", {
    --     desc = "Fix all ESLint issues",
    --     buffer = bufnr,
    --   })
    -- end

    servers.svelte.on_attach = function(client, bufnr)
      on_attach(client, bufnr)

      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.js", "*.ts" },
        callback = function(ctx)
          if client.name == "svelte" then
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
          end
        end,
      })
    end

    servers.rust_analyzer.on_attach = function(client, bufnr)
      on_attach(client, bufnr)

      map("n", "<leader>a", function()
        vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
        -- or vim.lsp.buf.codeAction() if you don't want grouping.
      end, { silent = true, buffer = bufnr })

      -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
      map("n", "K", function()
        vim.cmd.RustLsp({ "hover", "actions" })
      end, { silent = true, buffer = bufnr })
    end

    servers.jsonls = {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    }

    servers.yamlls = {
      settings = {
        yaml = {
          schemaStore = { enable = false, url = "" },
          schemas = require("schemastore").yaml.schemas(),
        },
      },
    }

    -- local ensure_installed = vim.tbl_keys(servers or {})
    --
    -- require("mason").setup()
    -- require("mason-lspconfig").setup({
    --   ensure_installed = ensure_installed,
    -- })

    for server, settings in pairs(servers) do
      vim.lsp.config(server, vim.tbl_extend("force", { on_attach = on_attach }, settings))
      vim.lsp.enable(server)
    end
  end,
}

-- LazyVim
-- return {
--   "neovim/nvim-lspconfig",
--   opts = {
--     -- make sure mason installs the server
--     servers = {
--       --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
--       --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
--       tsserver = {
--         enabled = false,
--       },
--       ts_ls = {
--         enabled = false,
--       },
--       vtsls = {
--         -- explicitly add default filetypes, so that we can extend
--         -- them in related extras
--         filetypes = {
--           "javascript",
--           "javascriptreact",
--           "javascript.jsx",
--           "typescript",
--           "typescriptreact",
--           "typescript.tsx",
--         },
--         settings = {
--           complete_function_calls = true,
--           vtsls = {
--             enableMoveToFileCodeAction = true,
--             autoUseWorkspaceTsdk = true,
--             experimental = {
--               maxInlayHintLength = 30,
--               completion = {
--                 enableServerSideFuzzyMatch = true,
--               },
--             },
--           },
--           typescript = {
--             updateImportsOnFileMove = { enabled = "always" },
--             suggest = {
--               completeFunctionCalls = true,
--             },
--             inlayHints = {
--               enumMemberValues = { enabled = true },
--               functionLikeReturnTypes = { enabled = true },
--               parameterNames = { enabled = "literals" },
--               parameterTypes = { enabled = true },
--               propertyDeclarationTypes = { enabled = true },
--               variableTypes = { enabled = false },
--             },
--           },
--         },
--         keys = {
--           {
--             "gD",
--             function()
--               local params = vim.lsp.util.make_position_params()
--               LazyVim.lsp.execute({
--                 command = "typescript.goToSourceDefinition",
--                 arguments = { params.textDocument.uri, params.position },
--                 open = true,
--               })
--             end,
--             desc = "Goto Source Definition",
--           },
--           {
--             "gR",
--             function()
--               LazyVim.lsp.execute({
--                 command = "typescript.findAllFileReferences",
--                 arguments = { vim.uri_from_bufnr(0) },
--                 open = true,
--               })
--             end,
--             desc = "File References",
--           },
--           {
--             "<leader>co",
--             LazyVim.lsp.action["source.organizeImports"],
--             desc = "Organize Imports",
--           },
--           {
--             "<leader>cM",
--             LazyVim.lsp.action["source.addMissingImports.ts"],
--             desc = "Add missing imports",
--           },
--           {
--             "<leader>cu",
--             LazyVim.lsp.action["source.removeUnused.ts"],
--             desc = "Remove unused imports",
--           },
--           {
--             "<leader>cD",
--             LazyVim.lsp.action["source.fixAll.ts"],
--             desc = "Fix all diagnostics",
--           },
--           {
--             "<leader>cV",
--             function()
--               LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
--             end,
--             desc = "Select TS workspace version",
--           },
--         },
--       },
--     },
--     setup = {
--       --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
--       --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
--       tsserver = function()
--         -- disable tsserver
--         return true
--       end,
--       ts_ls = function()
--         -- disable tsserver
--         return true
--       end,
--       vtsls = function(_, opts)
--         LazyVim.lsp.on_attach(function(client, buffer)
--           client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
--             ---@type string, string, lsp.Range
--             local action, uri, range = unpack(command.arguments)
--
--             local function move(newf)
--               client.request("workspace/executeCommand", {
--                 command = command.command,
--                 arguments = { action, uri, range, newf },
--               })
--             end
--
--             local fname = vim.uri_to_fname(uri)
--             client.request("workspace/executeCommand", {
--               command = "typescript.tsserverRequest",
--               arguments = {
--                 "getMoveToRefactoringFileSuggestions",
--                 {
--                   file = fname,
--                   startLine = range.start.line + 1,
--                   startOffset = range.start.character + 1,
--                   endLine = range["end"].line + 1,
--                   endOffset = range["end"].character + 1,
--                 },
--               },
--             }, function(_, result)
--               ---@type string[]
--               local files = result.body.files
--               table.insert(files, 1, "Enter new path...")
--               vim.ui.select(files, {
--                 prompt = "Select move destination:",
--                 format_item = function(f)
--                   return vim.fn.fnamemodify(f, ":~:.")
--                 end,
--               }, function(f)
--                 if f and f:find("^Enter new path") then
--                   vim.ui.input({
--                     prompt = "Enter move destination:",
--                     default = vim.fn.fnamemodify(fname, ":h") .. "/",
--                     completion = "file",
--                   }, function(newf)
--                     return newf and move(newf)
--                   end)
--                 elseif f then
--                   move(f)
--                 end
--               end)
--             end)
--           end
--         end, "vtsls")
--         -- copy typescript settings to javascript
--         opts.settings.javascript =
--           vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
--       end,
--     },
--   },
-- }
