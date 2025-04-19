local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

local M = {}

M.plugin = {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
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
      -- TODO: Until these are merged, defaults have to stay.
      -- https://github.com/neovim/nvim-lspconfig/pull/3731
      -- https://github.com/neovim/nvim-lspconfig/pull/3751
      local config =
        vim.tbl_deep_extend("force", M.defaults[server] or {}, { enabled = true, on_attach = M.on_attach }, settings)
      vim.lsp.config(server, config)
      vim.lsp.enable(server, config.enabled)
    end
  end,
}

M.servers = {
  -- TypeScript / JavaScript
  ts_ls = {
    -- NOTE: When vtsls is slow, switching to ts_ls is useful
    enabled = false,
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)

      local opts = function(desc)
        return { desc = desc, buffer = bufnr, silent = true, noremap = true }
      end

      map("n", "<leader>ci", M.lsp_action["source.organizeImports"], opts("Organize Imports"))
      map("n", "<leader>cT", function()
        M.toggle_ts_server(client)
      end, opts("Toggle vtsls"))
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

      map("n", "<leader>cT", function()
        M.toggle_ts_server(client)
      end, opts("Toggle ts_ls"))

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

      autocmd("BufWritePost", {
        pattern = { "*.js", "*.ts" },
        callback = function(ctx)
          if client.name == "svelte" then
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
          end
        end,
      })
    end,
  },
  biome = {
    -- NOTE: This is a workaround for an issue of biome instantiating itself for files
    -- that do not have biome installed in the project.
    -- Upgrading to nightly solves this, but I want to stay on 0.11 for now.
    -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/biome.lua#L29
    root_dir = function(bufnr, on_dir)
      local fname = vim.api.nvim_buf_get_name(bufnr)
      local root_files = { "biome.json", "biome.jsonc" }
      root_files = require("lspconfig.util").insert_package_json(root_files, "biome", fname)
      local root_dir = vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1])
      -- Modified only here to prevent on_dir from executing when root_dir is not found
      return root_dir and on_dir(root_dir)
    end,
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)

      local biome_executable = client.config.cmd[1]

      map("n", "<leader>cl", function()
        local cmd = { biome_executable, "check", vim.api.nvim_buf_get_name(bufnr), "--fix", "--unsafe" }
        M.execute_system_cmd_and_sync_buf(cmd)
      end, { buffer = bufnr, desc = "Biome: Fix Unsafe" })

      map("n", "<leader>cL", function()
        local cmd = { biome_executable, "check", ".", "--fix", "--unsafe" }
        M.execute_system_cmd_and_sync_buf(cmd)
      end, { buffer = bufnr, desc = "Biome: Fix Unsafe (Workspace)" })
    end,
  },
  eslint = {
    -- Makes ESLint work in monorepos (???)
    -- settings = { workingDirectory = { mode = "auto" } },
    -- root_dir = lspconfig.util.find_git_ancestor,

    root_dir = function(fname)
      local root_files = {
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
      local root_file = util.insert_package_json(root_files, "eslintConfig", fname)
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

      autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          if not vim.g.disable_autoformat then
            vim.cmd("EslintFixAll")
          end
        end,
      })

      map("n", "<leader>cl", ":EslintFixAll<CR>", {
        desc = "Fix all ESLint issues",
        buffer = bufnr,
      })
    end,
  },
  cssls = {},
  astro = {},
  tailwindcss = {},
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

---@param client vim.lsp.Client
M.toggle_ts_server = function(client)
  local new_server_name = client.name == "vtsls" and "ts_ls" or "vtsls"
  vim.lsp.enable("vtsls", new_server_name == "vtsls")
  vim.lsp.enable("ts_ls", new_server_name == "ts_ls")

  for buf_id, _ in pairs(client.attached_buffers) do
    vim.lsp.buf_detach_client(buf_id, client.id)
    vim.b[buf_id].navic_client_id = nil
  end

  vim.cmd("silent! e")

  vim.defer_fn(function()
    local new_server_id = vim.lsp.get_clients({ name = new_server_name })[1].id
    for buf_id, _ in pairs(client.attached_buffers) do
      vim.lsp.buf_attach_client(buf_id, new_server_id)
    end
  end, 1000)
end

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
    return require("trouble").open({ mode = "lsp_command", params = params })
  end

  return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
end

M.execute_system_cmd_and_sync_buf = function(cmd)
  vim.system(cmd, { detach = true }, function(obj)
    vim.notify(obj.stdout, vim.log.levels.INFO)
    vim.schedule(function()
      vim.cmd("silent! checktime")
    end)
  end)
end

M.on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  local opts = function(desc)
    return { desc = desc, noremap = true, silent = true, buffer = bufnr }
  end

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("See available code actions"))
  map("n", "<leader>cn", vim.lsp.buf.rename, opts("Smart rename"))
  map("n", "<leader>cr", function()
    for _, buf_client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
      for buf_id, _ in pairs(buf_client.attached_buffers) do
        vim.lsp.buf_detach_client(buf_id, buf_client.id)
        vim.defer_fn(function()
          vim.lsp.buf_attach_client(buf_id, buf_client.id)
        end, 500)
      end
    end
  end, opts("Restart LSP"))
  map({ "n", "v" }, "<leader>cq", function()
    vim.diagnostic.setqflist({ open = false })

    -- require("quicker").toggle()
    require("trouble").open({ mode = "quickfix", focus = false })
  end, opts("Populate qflist with diagnostics"))
end

M.eslint_alerted = false

M.defaults = {
  tailwindcss = {
    cmd = { "tailwindcss-language-server", "--stdio" },
    -- filetypes copied and adjusted from tailwindcss-intellisense
    filetypes = {
      -- html
      "aspnetcorerazor",
      "astro",
      "astro-markdown",
      "blade",
      "clojure",
      "django-html",
      "htmldjango",
      "edge",
      "eelixir", -- vim ft
      "elixir",
      "ejs",
      "erb",
      "eruby", -- vim ft
      "gohtml",
      "gohtmltmpl",
      "haml",
      "handlebars",
      "hbs",
      "html",
      "htmlangular",
      "html-eex",
      "heex",
      "jade",
      "leaf",
      "liquid",
      "markdown",
      "mdx",
      "mustache",
      "njk",
      "nunjucks",
      "php",
      "razor",
      "slim",
      "twig",
      -- css
      "css",
      "less",
      "postcss",
      "sass",
      "scss",
      "stylus",
      "sugarss",
      -- js
      "javascript",
      "javascriptreact",
      "reason",
      "rescript",
      "typescript",
      "typescriptreact",
      -- mixed
      "vue",
      "svelte",
      "templ",
    },
    settings = {
      tailwindCSS = {
        validate = true,
        lint = {
          cssConflict = "warning",
          invalidApply = "error",
          invalidScreen = "error",
          invalidVariant = "error",
          invalidConfigPath = "error",
          invalidTailwindDirective = "error",
          recommendedVariantOrder = "warning",
        },
        classAttributes = {
          "class",
          "className",
          "class:list",
          "classList",
          "ngClass",
        },
        includeLanguages = {
          eelixir = "html-eex",
          eruby = "erb",
          templ = "html",
          htmlangular = "html",
        },
      },
    },
    before_init = function(_, config)
      if not config.settings then
        config.settings = {}
      end
      if not config.settings.editor then
        config.settings.editor = {}
      end
      if not config.settings.editor.tabSize then
        config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
      end
    end,
    root_markers = {
      "tailwind.config.js",
      "tailwind.config.cjs",
      "tailwind.config.mjs",
      "tailwind.config.ts",
      "postcss.config.js",
      "postcss.config.cjs",
      "postcss.config.mjs",
      "postcss.config.ts",
    },
  },
  eslint = {
    cmd = { "vscode-eslint-language-server", "--stdio" },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
      "vue",
      "svelte",
      "astro",
    },
    on_init = function(client)
      vim.api.nvim_create_user_command("EslintFixAll", function()
        local bufnr = vim.api.nvim_get_current_buf()

        client:exec_cmd({
          title = "Fix all Eslint errors for current buffer",
          command = "eslint.applyAllFixes",
          arguments = {
            {
              uri = vim.uri_from_bufnr(bufnr),
              version = lsp.util.buf_versions[bufnr],
            },
          },
        }, { bufnr = bufnr })
      end, {})
    end,
    -- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
    root_dir = function(bufnr, on_dir)
      local root_file_patterns = {
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

      local fname = vim.api.nvim_buf_get_name(bufnr)
      root_file_patterns = util.insert_package_json(root_file_patterns, "eslintConfig", fname)
      local root_dir = vim.fs.dirname(vim.fs.find(root_file_patterns, { path = fname, upward = true })[1])
      on_dir(root_dir)
    end,
    -- Refer to https://github.com/Microsoft/vscode-eslint#settings-options for documentation.
    settings = {
      validate = "on",
      packageManager = nil,
      useESLintClass = false,
      experimental = {
        useFlatConfig = false,
      },
      codeActionOnSave = {
        enable = false,
        mode = "all",
      },
      format = true,
      quiet = false,
      onIgnoredFiles = "off",
      rulesCustomizations = {},
      run = "onType",
      problems = {
        shortenToSingleLine = false,
      },
      -- nodePath configures the directory in which the eslint server should start its node_modules resolution.
      -- This path is relative to the workspace folder (root dir) of the server instance.
      nodePath = "",
      -- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
      workingDirectory = { mode = "location" },
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = "separateLine",
        },
        showDocumentation = {
          enable = true,
        },
      },
    },
    before_init = function(_, config)
      -- The "workspaceFolder" is a VSCode concept. It limits how far the
      -- server will traverse the file system when locating the ESLint config
      -- file (e.g., .eslintrc).
      local root_dir = config.root_dir

      if root_dir then
        config.settings = config.settings or {}
        config.settings.workspaceFolder = {
          uri = root_dir,
          name = vim.fn.fnamemodify(root_dir, ":t"),
        }

        -- Support flat config
        local flat_config_files = {
          "eslint.config.js",
          "eslint.config.mjs",
          "eslint.config.cjs",
          "eslint.config.ts",
          "eslint.config.mts",
          "eslint.config.cts",
        }

        for _, file in ipairs(flat_config_files) do
          if vim.fn.filereadable(root_dir .. "/" .. file) == 1 then
            config.settings.experimental = config.settings.experimental or {}
            config.settings.experimental.useFlatConfig = true
            break
          end
        end

        -- Support Yarn2 (PnP) projects
        local pnp_cjs = root_dir .. "/.pnp.cjs"
        local pnp_js = root_dir .. "/.pnp.js"
        if vim.uv.fs_stat(pnp_cjs) or vim.uv.fs_stat(pnp_js) then
          local cmd = config.cmd
          config.cmd = vim.list_extend({ "yarn", "exec" }, cmd)
        end
      end
    end,
    handlers = {
      ["eslint/openDoc"] = function(_, result)
        if result then
          vim.ui.open(result.url)
        end
        return {}
      end,
      ["eslint/confirmESLintExecution"] = function(_, result)
        if not result then
          return
        end
        return 4 -- approved
      end,
      ["eslint/probeFailed"] = function()
        vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
        return {}
      end,
      ["eslint/noLibrary"] = function()
        vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
        return {}
      end,
    },
  },
}

return M.plugin
