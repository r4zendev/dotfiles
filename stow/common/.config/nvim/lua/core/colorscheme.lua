local M = {}

local function hex_to_rgb(hex)
  return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end

local function int_to_rgb(c)
  return bit.rshift(bit.band(c, 0xFF0000), 16),
    bit.rshift(bit.band(c, 0x00FF00), 8),
    bit.band(c, 0x0000FF)
end

local function rgb_to_hex(r, g, b)
  return string.format(
    "#%02x%02x%02x",
    math.min(255, math.max(0, math.floor(r))),
    math.min(255, math.max(0, math.floor(g))),
    math.min(255, math.max(0, math.floor(b)))
  )
end

local function lighten(hex, amount)
  local r, g, b = hex_to_rgb(hex)
  return rgb_to_hex(r + (255 - r) * amount, g + (255 - g) * amount, b + (255 - b) * amount)
end

local function blend_int(fg_int, bg_int, alpha)
  local fr, fg, fb = int_to_rgb(fg_int)
  local br, bg, bb = int_to_rgb(bg_int)
  return rgb_to_hex(
    fr * alpha + br * (1 - alpha),
    fg * alpha + bg * (1 - alpha),
    fb * alpha + bb * (1 - alpha)
  )
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
end

local function default_harpoon()
  vim.api.nvim_set_hl(0, "HarpoonOptionHL", { fg = "#89DDFF" })
  vim.api.nvim_set_hl(0, "HarpoonSelectedOptionHL", { fg = "#5DE4C7" })
end

local function minicursorword()
  local cl = vim.api.nvim_get_hl(0, { name = "CursorLine" })
  local func = vim.api.nvim_get_hl(0, { name = "Function" })
  if not cl.bg or not func.fg then
    return
  end
  local word_bg = blend_int(func.fg, cl.bg, 0.25)
  vim.api.nvim_set_hl(0, "MiniCursorword", { bg = word_bg })
  vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { bg = word_bg })
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

local function diagnostics()
  local diagnostic_underline = vim.api.nvim_get_hl(0, { name = "DiagnosticUnderline" })
  diagnostic_underline.underline = true
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", diagnostic_underline)
end

---@param disable? boolean If true, removes bold styling from selected nodes instead
local function ts_lsp_bold_nodes(disable)
  local nodes = {
    "@lsp.type.function",
    "@function",
    "Function",
    "Green",
  }
  for _, node in ipairs(nodes) do
    vim.api.nvim_set_hl(
      0,
      node,
      vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = node }), { bold = not disable })
    )
  end
end

M.pywal_data = nil
M._pywal_raw = nil

local function load_pywal_data()
  local file = io.open(vim.fn.expand("~/.cache/wal/colors.json"), "r")
  if not file then
    vim.notify("pywal: No colors at ~/.cache/wal/colors.json", vim.log.levels.WARN)
    return nil
  end
  local content = file:read("*all")
  file:close()

  local ok, data = pcall(vim.json.decode, content)
  if not ok or not data then
    return nil
  end
  M._pywal_raw = content
  M.pywal_data = data
  return data
end

local function apply_pywal()
  local data = load_pywal_data()
  if not data then
    return false
  end

  vim.cmd("hi clear")
  vim.g.colors_name = "pywal"
  vim.o.background = "dark"

  local bg = data.special.background
  local fg = data.special.foreground
  local c = data.colors

  local subtle = lighten(bg, 0.1)

  local hi = vim.api.nvim_set_hl
  hi(0, "Normal", { fg = fg, bg = "NONE" })
  hi(0, "NormalFloat", { fg = fg, bg = "NONE" })
  hi(0, "FloatBorder", { fg = c.color8, bg = "NONE" })
  hi(0, "CursorLine", { bg = subtle })
  hi(0, "Visual", { bg = c.color8 })
  hi(0, "LineNr", { fg = c.color8 })
  hi(0, "CursorLineNr", { fg = c.color4, bold = true })
  hi(0, "Search", { fg = bg, bg = c.color3 })
  hi(0, "IncSearch", { fg = bg, bg = c.color5 })
  hi(0, "Comment", { fg = c.color8, italic = true })
  hi(0, "String", { fg = c.color2 })
  hi(0, "Function", { fg = c.color4, bold = true })
  hi(0, "Keyword", { fg = c.color1 })
  hi(0, "Type", { fg = c.color3 })
  hi(0, "Constant", { fg = c.color5 })
  hi(0, "Identifier", { fg = fg })
  hi(0, "Special", { fg = c.color6 })
  hi(0, "Statement", { fg = c.color1 })
  hi(0, "PreProc", { fg = c.color3 })
  hi(0, "Operator", { fg = c.color6 })
  hi(0, "Pmenu", { fg = fg, bg = c.color0 })
  hi(0, "PmenuSel", { fg = fg, bg = c.color8, bold = true })

  return true
end

M.themes = {
  {
    name = "System (pywal)",
    colorscheme = "pywal",
    custom_apply = apply_pywal,
    after = function()
      transparent_winbar()
      transparent_float()
      transparent_neotree()
    end,
  },
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
    name = "Everforest",
    colorscheme = "everforest",
    after = function()
      transparent_winbar()
      transparent_float()
    end,
  },
  {
    name = "Catppuccin",
    colorscheme = "catppuccin-mocha",
    after = function()
      transparent_float()
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

  vim.g.THEME = name

  local ok
  if theme.custom_apply then
    ok = theme.custom_apply()
  else
    ok = pcall(vim.cmd.colorscheme, theme.colorscheme)
  end

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
    diagnostics()

    -- For custom_apply themes, fire ColorScheme so plugins (lualine etc.) update.
    -- :colorscheme already fires this for built-in themes.
    if theme.custom_apply then
      vim.cmd("doautocmd ColorScheme " .. (theme.colorscheme or ""))
    end

    -- Re-assert diagnostic colors after all plugin ColorScheme handlers settle
    if theme.colorscheme == "pywal" then
      vim.schedule(function()
        if vim.g.colors_name ~= "pywal" then
          return
        end
        local hi = vim.api.nvim_set_hl
        hi(0, "DiagnosticError", { fg = "#f38ba8" })
        hi(0, "DiagnosticWarn", { fg = "#f9e2af" })
        hi(0, "DiagnosticInfo", { fg = "#89b4fa" })
        hi(0, "DiagnosticHint", { fg = "#a6e3a1" })
        hi(0, "GitSignsAdd", { fg = "#a6e3a1" })
        hi(0, "GitSignsChange", { fg = "#f9e2af" })
        hi(0, "GitSignsDelete", { fg = "#f38ba8" })
        hi(0, "DiffAdd", { fg = "#a6e3a1", bg = "NONE" })
        hi(0, "DiffChange", { fg = "#f9e2af", bg = "NONE" })
        hi(0, "DiffDelete", { fg = "#f38ba8", bg = "NONE" })
        hi(0, "llama_hl_fim_hint", { link = "Comment" })
        transparent_statusline()
      end)
    end
  end
  return ok
end

local group = vim.api.nvim_create_augroup("CoreColorscheme", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  nested = true,
  callback = function()
    M.apply(vim.g.THEME)
  end,
})

vim.api.nvim_create_autocmd("FocusGained", {
  group = group,
  callback = function()
    if vim.g.THEME ~= "System (pywal)" then
      return
    end

    local file = io.open(vim.fn.expand("~/.cache/wal/colors.json"), "r")

    if not file then
      return
    end

    local content = file:read("*all")
    file:close()

    if content == M._pywal_raw then
      return
    end

    M.apply("System (pywal)")
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
        height = #M.themes + 2,
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
