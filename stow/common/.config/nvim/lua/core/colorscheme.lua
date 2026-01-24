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

local function transparent_neotree()
  vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { bg = "NONE" })
end

local function transparent_statusline()
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
  -- vim.api.nvim_set_hl(0, "StatusLineTerm", { bg = "NONE" })
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
  vim.api.nvim_set_hl(
    0,
    "TreesitterContext",
    { bg = vim.api.nvim_get_hl(0, { name = "CursorLine" }).bg }
  )
  vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = false })
end

local function flash_search()
  vim.api.nvim_set_hl(0, "FlashCurrent", { link = "CurSearch" })
  vim.api.nvim_set_hl(0, "FlashMatch", { link = "Search" })
end

local function mini_diff_overlay()
  vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { bg = "#1e3a2f", fg = "#a6e3a1" })
  vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { bg = "#3a1e1e", fg = "#f38ba8" })
  vim.api.nvim_set_hl(0, "MiniDiffOverChange", { bg = "#3a351e", fg = "#f9e2af" })
  vim.api.nvim_set_hl(0, "MiniDiffOverContext", { fg = "#6c7086" })
end

---@param disable? boolean If true, removes bold styling from selected nodes instead
local function ts_lsp_bold_nodes(disable)
  local nodes = {
    "@lsp.type.function",
    "@function",
    "Function",
  }
  for _, node in ipairs(nodes) do
    vim.api.nvim_set_hl(
      0,
      node,
      vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = node }), { bold = not disable })
    )
  end
end

M.themes = {
  {
    name = "Tokyo Night",
    colorscheme = "tokyonight",
    after = function()
      transparent_winbar()
      transparent_float()
      transparent_neotree()
    end,
  },
  {
    name = "Everblush",
    colorscheme = "everblush",
    after = function()
      transparent_winbar()

      local palette = require("everblush.palette")
      local comment_color = "#6c7086"
      vim.api.nvim_set_hl(0, "@comment", { fg = comment_color })
      vim.api.nvim_set_hl(0, "Comment", { fg = comment_color })
      vim.api.nvim_set_hl(0, "LineNr", { fg = comment_color })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = palette.color4, bold = true })
      vim.api.nvim_set_hl(
        0,
        "SnacksPickerListCursorLine",
        { bg = vim.api.nvim_get_hl(0, { name = "Visual" }).bg, fg = "NONE" }
      )
    end,
  },
  {
    name = "Catppuccin",
    colorscheme = "catppuccin-mocha",
    after = function()
      transparent_float()
    end,
  },
  {
    name = "VSCode",
    colorscheme = "vscode",
  },
  {
    name = "Kanagawa Wave",
    colorscheme = "kanagawa-wave",
    after = transparent_background,
  },
  {
    name = "Kanso Zen",
    colorscheme = "kanso-zen",
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
  if ok then
    if theme.after then
      theme.after()
    end

    minicursorword()
    ts_context()
    mini_diff_overlay()
    flash_search()
    ts_lsp_bold_nodes()
    default_harpoon()
    transparent_statusline()
  end
  return ok
end

vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    M.apply(vim.g.THEME)
  end,
})

function M.pick()
  local prev = vim.g.THEME
  local confirmed = false

  local items = {}
  local current_theme_item = nil

  for _, theme in ipairs(M.themes) do
    if theme.name == vim.g.THEME then
      current_theme_item = { text = theme.name, theme = theme }
      table.insert(items, current_theme_item)
      break
    end
  end

  for _, theme in ipairs(M.themes) do
    if theme.name ~= vim.g.THEME then
      table.insert(items, { text = theme.name, theme = theme })
    end
  end

  Snacks.picker.pick({
    title = "Colorschemes",
    items = items,
    preview = nil,
    layout = {
      preset = "select",
      layout = {
        height = 8,
        width = 20,
        min_width = 20,
      },
    },
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
    on_show = function()
      vim.cmd.stopinsert()
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
  })
end

vim.keymap.set("n", "<leader>uc", M.pick, { desc = "Colorscheme picker" })

return M
