local M = {}

local function transparent_background()
  vim.api.nvim_set_hl(0, "NonText", { bg = "NONE" })
  pcall(vim.api.nvim_set_hl, 0, "StatusColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
end

local function transparent_winbar()
  vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
end

local function transparent_float()
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatTitle", { bg = "NONE" })
end

local function default_harpoon()
  vim.api.nvim_set_hl(0, "HarpoonOptionHL", { fg = "#89DDFF" })
  vim.api.nvim_set_hl(0, "HarpoonSelectedOptionHL", { fg = "#5DE4C7" })
end

local function minicursorword()
  vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#506477" })
  vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { bg = "#506477" })
end

local function ts_context()
  vim.api.nvim_set_hl(0, "TreesitterContext", { bg = vim.api.nvim_get_hl(0, { name = "CursorLine" }).bg })
  vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = false })
end

local function custom_blink_cmp()
  vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#1e1e2e", fg = "#cdd6f4" })
  vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "#1e1e2e", fg = "#89b4fa" })
  vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#45475a", fg = "#cdd6f4" })
  vim.api.nvim_set_hl(0, "BlinkCmpLabel", { fg = "#cdd6f4" })
  vim.api.nvim_set_hl(0, "BlinkCmpLabelDeprecated", { fg = "#6c7086", strikethrough = true })
  vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#89b4fa", bold = true })
  vim.api.nvim_set_hl(0, "BlinkCmpKind", { fg = "#cba6f7" })
  vim.api.nvim_set_hl(0, "BlinkCmpSource", { fg = "#6c7086" })
  vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = "#6c7086" })
  vim.api.nvim_set_hl(0, "BlinkCmpKindFunction", { fg = "#89b4fa" })
  vim.api.nvim_set_hl(0, "BlinkCmpKindVariable", { fg = "#f5c2e7" })
  vim.api.nvim_set_hl(0, "BlinkCmpKindKeyword", { fg = "#f38ba8" })
  vim.api.nvim_set_hl(0, "BlinkCmpKindSnippet", { fg = "#a6e3a1" })
end

M.themes = {
  {
    name = "Tokyo Night",
    colorscheme = "tokyonight",
    after = function()
      transparent_winbar()
      transparent_float()
    end,
  },
  {
    name = "Oxocarbon",
    colorscheme = "oxocarbon",
    after = function()
      transparent_background()
      transparent_winbar()
      transparent_float()
      minicursorword()
      default_harpoon()
      ts_context()
      vim.api.nvim_set_hl(0, "Comment", { fg = "#737aa2" })
      vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#627E97", bg = "#011423" })
      vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#666666" })
      vim.api.nvim_set_hl(0, "SnacksPickerMatch", { fg = "#3DDBD9" })
      vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", { bg = "#191919" })
      vim.api.nvim_set_hl(0, "Visual", { bg = "#191919" })
    end,
  },
  {
    name = "Catppuccin",
    colorscheme = "catppuccin-mocha",
    after = function()
      transparent_float()
      ts_context()
    end,
  },
  {
    name = "Rose Pine",
    colorscheme = "rose-pine",
    after = function()
      transparent_winbar()
      ts_context()
    end,
  },
  {
    name = "Kanagawa Wave",
    colorscheme = "kanagawa-wave",
    after = transparent_background,
  },
  {
    name = "Vague",
    colorscheme = "vague",
    after = transparent_winbar,
  },
  {
    name = "Nightfly",
    colorscheme = "nightfly",
    after = ts_context,
  },
  {
    name = "Oxocarbon Dark",
    colorscheme = "oxocarbon",
    after = function()
      minicursorword()
      ts_context()
      custom_blink_cmp()
    end,
  },
  {
    name = "Kanso Zen",
    colorscheme = "kanso-zen",
  },
  {
    name = "Default",
    colorscheme = "default",
    after = function()
      default_harpoon()
      minicursorword()
      ts_context()
    end,
  },
}

vim.g.THEME = vim.g.THEME or "Tokyo Night"

function M.get_theme(name)
  for _, theme in ipairs(M.themes) do
    if theme.name == name then
      return theme
    end
  end
  return nil
end

function M.apply(name)
  local theme = M.get_theme(name)
  if not theme then
    return false
  end

  local ok = pcall(vim.cmd.colorscheme, theme.colorscheme)
  if ok and theme.after then
    theme.after()
  end
  return ok
end

vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    M.apply(vim.g.THEME)
  end,
})

local function find_index(name)
  for i, theme in ipairs(M.themes) do
    if theme.name == name then
      return i
    end
  end
  return 1
end

function M.pick()
  local prev = vim.g.THEME
  local confirmed = false

  local items = {}
  for _, theme in ipairs(M.themes) do
    table.insert(items, { text = theme.name, theme = theme })
  end

  Snacks.picker.pick({
    title = "Colorschemes",
    items = items,
    preview = nil,
    layout = { preset = "select", layout = { width = 0.3, height = 0.4 } },
    format = function(item)
      return { { item.theme.name } }
    end,
    confirm = function(picker, item)
      confirmed = true
      if item then
        vim.g.THEME = item.theme.name
        M.apply(item.theme.name)
      end
      picker:close()
    end,
    on_change = function(_, item)
      if item then
        M.apply(item.theme.name)
      end
    end,
    on_close = function()
      if not confirmed then
        M.apply(prev)
      end
    end,
    initial = function()
      return find_index(vim.g.THEME)
    end,
  })
end

vim.keymap.set("n", "<leader>uc", M.pick, { desc = "Colorscheme picker" })

return M
