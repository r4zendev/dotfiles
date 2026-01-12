local map = vim.keymap.set

local M = {}

M.plugin = {
  "echasnovski/mini.nvim",
  event = "LazyFile",
  config = function()
    require("mini.icons").setup({ file = M.file_icon_config })
    MiniIcons.mock_nvim_web_devicons()

    local ai = require("mini.ai")
    ai.setup({
      n_lines = 9999,
      custom_textobjects = {
        ["|"] = ai.gen_spec.pair("|", "|", { type = "balanced" }),
      },
    })

    require("mini.align").setup()

    require("mini.bracketed").setup()
    map("n", "[t", vim.cmd.tabprev, { desc = "Previous tabpage" })
    map("n", "]t", vim.cmd.tabnext, { desc = "Next tabpage" })

    require("mini.surround").setup({ n_lines = 9999 })

    require("mini.splitjoin").setup()

    require("mini.cursorword").setup()

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
    map("n", "<leader>=", function()
      MiniDiff.toggle_overlay(0)
    end, { desc = "Toggle diff overlay" })

    require("mini.move").setup({
      mappings = {
        left = "H",
        down = "J",
        up = "K",
        right = "L",

        line_left = "",
        line_right = "",
        line_down = "",
        line_up = "",
      },
    })

    -- require("mini.notify").setup()
    -- vim.notify = MiniNotify.make_notify()
    -- vim.keymap.set("n", "<leader>cc", function()
    --   MiniNotify.clear()
    -- end, { desc = "Clear Notifications" })
    -- vim.keymap.set("n", "<leader>cm", function()
    --   M.open_notifications_history(MiniNotify.get_all())
    -- end, { desc = "Notifications History" })
  end,
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

M.open_notifications_history = function(notifications)
  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " Notification History ",
    title_pos = "center",
  })

  local lines = {}
  for _, notif in ipairs(notifications) do
    local msg = type(notif.msg) == "string" and notif.msg or vim.inspect(notif.msg)
    msg = msg:gsub("%%", "%%%%") -- Escape literal '%'
    msg = msg:gsub("\n", " ") -- Replace newlines with spaces
    table.insert(lines, string.format("[%s] %s", notif.level, msg))
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "log"
  vim.bo[buf].bufhidden = "wipe"

  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, silent = true, nowait = true, desc = "Close notification history" })
end

return M.plugin
