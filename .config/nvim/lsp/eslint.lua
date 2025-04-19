local util = require("r4zen.lsp_utils")
local lsp = vim.lsp
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

local eslint_alerted = false

return {
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

    local ignored_dirs = {
      os.getenv("HOME") .. "/projects/ballerine/oss",
    }

    for _, dir in ipairs(ignored_dirs) do
      if string.find(fname, dir) then
        -- Don't load ESLint for projects where it is broken
        return nil
      end
    end

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
  on_attach = function(client, bufnr)
    util.on_attach(client, bufnr)

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
      vim.notify("ESLint probe failed.", vim.log.levels.WARN)
      return {}
    end,
    ["eslint/noLibrary"] = function()
      vim.notify("Unable to find ESLint library.", vim.log.levels.WARN)
      return {}
    end,
  },
}
