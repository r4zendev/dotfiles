local M = {}

M.plugin = {
  {
    "echasnovski/mini.nvim",
    event = "LazyFile",
    config = function()
      require("mini.icons").setup({
        file = M.file_icon_config,
      })
      MiniIcons.mock_nvim_web_devicons()

      require("mini.ai").setup({ n_lines = 9999 })
      require("mini.align").setup()
      require("mini.bracketed").setup()
      require("mini.surround").setup({ n_lines = 9999 })
      require("mini.splitjoin").setup()
      require("mini.cursorword").setup()
      -- require("mini.operators").setup()

      require("mini.jump").setup()
      -- Don't start jump2d if using through `man` cmd, because it will break `gO` quickfix window
      -- with table of contents and make it unusable through <cr>
      local utils = require("r4zen.utils")
      if not utils.check_arg("+Man!") then
        require("mini.jump2d").setup()
      end

      local mini_indentscope = require("mini.indentscope")
      mini_indentscope.setup({
        symbol = "│",
        draw = {
          animation = mini_indentscope.gen_animation.linear({
            easing = "out",
            duration = 10,
          }),
        },
      })

      require("mini.diff").setup()
      vim.keymap.set("n", "<leader>=", function()
        MiniDiff.toggle_overlay(0)
      end, { desc = "Toggle diff overlay" })

      require("mini.move").setup({
        mappings = {
          left = "H",
          down = "J",
          up = "K",
          right = "L",
        },
      })

      require("mini.notify").setup({
        lsp_progress = {
          enable = false,
        },
      })
      -- vim.notify = MiniNotify.make_notify()
      -- vim.keymap.set("n", "<leader>cm", function()
      --   MiniNotify.clear()
      -- end, { desc = "Clear Notifications" })
      -- vim.keymap.set("n", "<leader>sn", function()
      --   M.open_notifications_history(MiniNotify.get_all())
      -- end, { desc = "Notifications History" })

      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

          -- Highlight hex color strings (`#rrggbb`) using that color
          -- Currently trying out `ccc.nvim`
          -- hex_color = hipatterns.gen_highlighter.hex_color(),

          -- Highlight tailwind colors
          tailwind = {
            pattern = function()
              if not vim.tbl_contains(M.tailwind_filetypes, vim.bo.filetype) then
                return
              end

              if M.tailwind_style == "full" then
                return "%f[%w:-]()[%w:-]+%-[a-z%-]+%-%d+()%f[^%w:-]"
              elseif M.tailwind_style == "compact" then
                return "%f[%w:-][%w:-]+%-()[a-z%-]+%-%d+()%f[^%w:-]"
              end
            end,
            group = function(_, _, m)
              ---@type string
              local match = m.full_match
              ---@type string, number
              local color, shade = match:match("[%w-]+%-([a-z%-]+)%-(%d+)")
              shade = tonumber(shade)
              local bg = vim.tbl_get(M.tailwind_colors, color, shade)
              if bg then
                local hl = "MiniHipatternsTailwind" .. color .. shade
                if not M.hl[hl] then
                  M.hl[hl] = true
                  local bg_shade = shade == 500 and 950 or shade < 500 and 900 or 100
                  local fg = vim.tbl_get(M.tailwind_colors, color, bg_shade)
                  vim.api.nvim_set_hl(0, hl, { bg = "#" .. bg, fg = "#" .. fg })
                end
                return hl
              end
            end,
            extmark_opts = { priority = 2000 },
          },
        },
      })
    end,
  },
}

M.icons = {
  eslint = { glyph = "󰱺", hl = "MiniIconsPurple" },
  prettier = { glyph = "", hl = "MiniIconsPurple" },
  node = { glyph = "", hl = "MiniIconsGreen" },
  npm = { glyph = "", hl = "MiniIconsRed" },
  yarn = { glyph = "", hl = "MiniIconsBlue" },
  pnpm = { glyph = "", hl = "MiniIconsOrange" },
  tsconfig_json = { glyph = "", hl = "MiniIconsAzure" },
  env = { glyph = "", hl = "MiniIconsWhite" },
  vite = { glyph = "", hl = "MiniIconsPurple" },
  vitest = { glyph = "", hl = "MiniIconsYellow" },
  playwright = { glyph = "", hl = "MiniIconsCyan" },
  postcss = { glyph = "", hl = "MiniIconsRed" },
  tailwind = { glyph = "", hl = "MiniIconsAzure" },
}

M.file_icon_config = {
  [".eslintignore"] = M.icons.eslint,
  [".eslintrc.js"] = M.icons.eslint,
  [".eslintrc.cjs"] = M.icons.eslint,
  [".eslintrc.mjs"] = M.icons.eslint,

  ["eslint.config.js"] = M.icons.eslint,
  ["eslint.config.cjs"] = M.icons.eslint,
  ["eslint.config.mjs"] = M.icons.eslint,

  [".prettierignore"] = M.icons.prettier,
  [".prettierrc"] = M.icons.prettier,
  [".prettierrc.js"] = M.icons.prettier,
  [".prettierrc.cjs"] = M.icons.prettier,
  [".prettierrc.mjs"] = M.icons.prettier,

  ["prettier.config.js"] = M.icons.prettier,
  ["prettier.config.cjs"] = M.icons.prettier,
  ["prettier.config.mjs"] = M.icons.prettier,

  [".npmrc"] = M.icons.npm,
  [".node-version"] = M.icons.node,
  [".nvmrc"] = M.icons.node,
  ["package.json"] = M.icons.node,

  [".yarnrc.yml"] = M.icons.yarn,
  ["yarn.lock"] = M.icons.yarn,

  ["pnpm-lock.yaml"] = M.icons.pnpm,
  ["pnpm-workspace.yaml"] = M.icons.pnpm,

  ["tsconfig.json"] = M.icons.tsconfig_json,
  ["tsconfig.build.json"] = M.icons.tsconfig_json,

  [".env"] = M.icons.env,
  [".env.example"] = M.icons.env,
  [".env.development"] = M.icons.env,
  [".env.test"] = M.icons.env,
  [".env.production"] = M.icons.env,

  ["vite.config.ts"] = M.icons.vite,
  ["vite.config.js"] = M.icons.vite,

  ["vitest.config.ts"] = M.icons.vite,
  ["vitest.config.js"] = M.icons.vite,

  ["playwright.config.ts"] = M.icons.playwright,
  ["playwright.config.js"] = M.icons.playwright,

  ["postcss.config.js"] = M.icons.postcss,
  ["postcss.config.ts"] = M.icons.postcss,
  ["postcss.config.mjs"] = M.icons.postcss,
  ["postcss.config.cjs"] = M.icons.postcss,
  ["postcss.config.mts"] = M.icons.postcss,
  ["postcss.config.cts"] = M.icons.postcss,

  ["tailwind.config.js"] = M.icons.tailwind,
  ["tailwind.config.ts"] = M.icons.tailwind,
  ["tailwind.config.mjs"] = M.icons.tailwind,
  ["tailwind.config.cjs"] = M.icons.tailwind,
  ["tailwind.config.mts"] = M.icons.tailwind,
  ["tailwind.config.cts"] = M.icons.tailwind,
}

M.hl = {}

M.tailwind_filetypes = {
  "astro",
  "css",
  "heex",
  "html",
  "html-eex",
  "javascript",
  "javascriptreact",
  "rust",
  "svelte",
  "typescript",
  "typescriptreact",
  "vue",
}

M.tailwind_style = "compact"

M.tailwind_colors = {
  slate = {
    [50] = "f8fafc",
    [100] = "f1f5f9",
    [200] = "e2e8f0",
    [300] = "cbd5e1",
    [400] = "94a3b8",
    [500] = "64748b",
    [600] = "475569",
    [700] = "334155",
    [800] = "1e293b",
    [900] = "0f172a",
    [950] = "020617",
  },

  gray = {
    [50] = "f9fafb",
    [100] = "f3f4f6",
    [200] = "e5e7eb",
    [300] = "d1d5db",
    [400] = "9ca3af",
    [500] = "6b7280",
    [600] = "4b5563",
    [700] = "374151",
    [800] = "1f2937",
    [900] = "111827",
    [950] = "030712",
  },

  zinc = {
    [50] = "fafafa",
    [100] = "f4f4f5",
    [200] = "e4e4e7",
    [300] = "d4d4d8",
    [400] = "a1a1aa",
    [500] = "71717a",
    [600] = "52525b",
    [700] = "3f3f46",
    [800] = "27272a",
    [900] = "18181b",
    [950] = "09090B",
  },

  neutral = {
    [50] = "fafafa",
    [100] = "f5f5f5",
    [200] = "e5e5e5",
    [300] = "d4d4d4",
    [400] = "a3a3a3",
    [500] = "737373",
    [600] = "525252",
    [700] = "404040",
    [800] = "262626",
    [900] = "171717",
    [950] = "0a0a0a",
  },

  stone = {
    [50] = "fafaf9",
    [100] = "f5f5f4",
    [200] = "e7e5e4",
    [300] = "d6d3d1",
    [400] = "a8a29e",
    [500] = "78716c",
    [600] = "57534e",
    [700] = "44403c",
    [800] = "292524",
    [900] = "1c1917",
    [950] = "0a0a0a",
  },

  red = {
    [50] = "fef2f2",
    [100] = "fee2e2",
    [200] = "fecaca",
    [300] = "fca5a5",
    [400] = "f87171",
    [500] = "ef4444",
    [600] = "dc2626",
    [700] = "b91c1c",
    [800] = "991b1b",
    [900] = "7f1d1d",
    [950] = "450a0a",
  },

  orange = {
    [50] = "fff7ed",
    [100] = "ffedd5",
    [200] = "fed7aa",
    [300] = "fdba74",
    [400] = "fb923c",
    [500] = "f97316",
    [600] = "ea580c",
    [700] = "c2410c",
    [800] = "9a3412",
    [900] = "7c2d12",
    [950] = "431407",
  },

  amber = {
    [50] = "fffbeb",
    [100] = "fef3c7",
    [200] = "fde68a",
    [300] = "fcd34d",
    [400] = "fbbf24",
    [500] = "f59e0b",
    [600] = "d97706",
    [700] = "b45309",
    [800] = "92400e",
    [900] = "78350f",
    [950] = "451a03",
  },

  yellow = {
    [50] = "fefce8",
    [100] = "fef9c3",
    [200] = "fef08a",
    [300] = "fde047",
    [400] = "facc15",
    [500] = "eab308",
    [600] = "ca8a04",
    [700] = "a16207",
    [800] = "854d0e",
    [900] = "713f12",
    [950] = "422006",
  },

  lime = {
    [50] = "f7fee7",
    [100] = "ecfccb",
    [200] = "d9f99d",
    [300] = "bef264",
    [400] = "a3e635",
    [500] = "84cc16",
    [600] = "65a30d",
    [700] = "4d7c0f",
    [800] = "3f6212",
    [900] = "365314",
    [950] = "1a2e05",
  },

  green = {
    [50] = "f0fdf4",
    [100] = "dcfce7",
    [200] = "bbf7d0",
    [300] = "86efac",
    [400] = "4ade80",
    [500] = "22c55e",
    [600] = "16a34a",
    [700] = "15803d",
    [800] = "166534",
    [900] = "14532d",
    [950] = "052e16",
  },

  emerald = {
    [50] = "ecfdf5",
    [100] = "d1fae5",
    [200] = "a7f3d0",
    [300] = "6ee7b7",
    [400] = "34d399",
    [500] = "10b981",
    [600] = "059669",
    [700] = "047857",
    [800] = "065f46",
    [900] = "064e3b",
    [950] = "022c22",
  },

  teal = {
    [50] = "f0fdfa",
    [100] = "ccfbf1",
    [200] = "99f6e4",
    [300] = "5eead4",
    [400] = "2dd4bf",
    [500] = "14b8a6",
    [600] = "0d9488",
    [700] = "0f766e",
    [800] = "115e59",
    [900] = "134e4a",
    [950] = "042f2e",
  },

  cyan = {
    [50] = "ecfeff",
    [100] = "cffafe",
    [200] = "a5f3fc",
    [300] = "67e8f9",
    [400] = "22d3ee",
    [500] = "06b6d4",
    [600] = "0891b2",
    [700] = "0e7490",
    [800] = "155e75",
    [900] = "164e63",
    [950] = "083344",
  },

  sky = {
    [50] = "f0f9ff",
    [100] = "e0f2fe",
    [200] = "bae6fd",
    [300] = "7dd3fc",
    [400] = "38bdf8",
    [500] = "0ea5e9",
    [600] = "0284c7",
    [700] = "0369a1",
    [800] = "075985",
    [900] = "0c4a6e",
    [950] = "082f49",
  },

  blue = {
    [50] = "eff6ff",
    [100] = "dbeafe",
    [200] = "bfdbfe",
    [300] = "93c5fd",
    [400] = "60a5fa",
    [500] = "3b82f6",
    [600] = "2563eb",
    [700] = "1d4ed8",
    [800] = "1e40af",
    [900] = "1e3a8a",
    [950] = "172554",
  },

  indigo = {
    [50] = "eef2ff",
    [100] = "e0e7ff",
    [200] = "c7d2fe",
    [300] = "a5b4fc",
    [400] = "818cf8",
    [500] = "6366f1",
    [600] = "4f46e5",
    [700] = "4338ca",
    [800] = "3730a3",
    [900] = "312e81",
    [950] = "1e1b4b",
  },

  violet = {
    [50] = "f5f3ff",
    [100] = "ede9fe",
    [200] = "ddd6fe",
    [300] = "c4b5fd",
    [400] = "a78bfa",
    [500] = "8b5cf6",
    [600] = "7c3aed",
    [700] = "6d28d9",
    [800] = "5b21b6",
    [900] = "4c1d95",
    [950] = "2e1065",
  },

  purple = {
    [50] = "faf5ff",
    [100] = "f3e8ff",
    [200] = "e9d5ff",
    [300] = "d8b4fe",
    [400] = "c084fc",
    [500] = "a855f7",
    [600] = "9333ea",
    [700] = "7e22ce",
    [800] = "6b21a8",
    [900] = "581c87",
    [950] = "3b0764",
  },

  fuchsia = {
    [50] = "fdf4ff",
    [100] = "fae8ff",
    [200] = "f5d0fe",
    [300] = "f0abfc",
    [400] = "e879f9",
    [500] = "d946ef",
    [600] = "c026d3",
    [700] = "a21caf",
    [800] = "86198f",
    [900] = "701a75",
    [950] = "4a044e",
  },

  pink = {
    [50] = "fdf2f8",
    [100] = "fce7f3",
    [200] = "fbcfe8",
    [300] = "f9a8d4",
    [400] = "f472b6",
    [500] = "ec4899",
    [600] = "db2777",
    [700] = "be185d",
    [800] = "9d174d",
    [900] = "831843",
    [950] = "500724",
  },

  rose = {
    [50] = "fff1f2",
    [100] = "ffe4e6",
    [200] = "fecdd3",
    [300] = "fda4af",
    [400] = "fb7185",
    [500] = "f43f5e",
    [600] = "e11d48",
    [700] = "be123c",
    [800] = "9f1239",
    [900] = "881337",
    [950] = "4c0519",
  },
}

-- M.open_notifications_history = function(notifications)
--   local buf = vim.api.nvim_create_buf(false, true)
--
--   local width = math.floor(vim.o.columns * 0.8)
--   local height = math.floor(vim.o.lines * 0.8)
--   local col = math.floor((vim.o.columns - width) / 2)
--   local row = math.floor((vim.o.lines - height) / 2)
--
--   local win = vim.api.nvim_open_win(buf, true, {
--     relative = "editor",
--     width = width,
--     height = height,
--     col = col,
--     row = row,
--     style = "minimal",
--     border = "rounded",
--     title = " Notification History ",
--     title_pos = "center",
--   })
--
--   local lines = {}
--   for _, notif in ipairs(notifications) do
--     local msg = type(notif.msg) == "string" and notif.msg or vim.inspect(notif.msg)
--     msg = msg:gsub("%%", "%%%%") -- Escape literal '%'
--     msg = msg:gsub("\n", " ") -- Replace newlines with spaces
--     table.insert(lines, string.format("[%s] %s", notif.level, msg))
--   end
--
--   vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
--
--   vim.bo[buf].modifiable = false
--   vim.bo[buf].filetype = "log"
--   vim.bo[buf].bufhidden = "wipe"
--
--   vim.keymap.set("n", "q", function()
--     vim.api.nvim_win_close(win, true)
--   end, { buffer = buf, silent = true, nowait = true, desc = "Close notification history" })
-- end

return M.plugin
