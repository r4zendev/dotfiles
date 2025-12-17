return {
  "rose-pine/neovim",
  name = "rose-pine",
  opts = {
    styles = {
      italic = false,
      transparency = true,
    },
    highlight_groups = {
      DiagnosticUnnecessary = { fg = "muted", bg = "_nc", underline = true },

      BlinkCmpLabel = { fg = "subtle" },
      BlinkCmpLabelMatch = { fg = "iris" },

      HarpoonOptionHL = { fg = "text" },
      HarpoonSelectedOptionHL = { fg = "foam" },

      CodeCompanionChatTool = { fg = "foam" },
      CodeCompanionChatVariable = { fg = "foam" },

      MiniCursorword = { bg = "highlight_med", underline = false },
      MiniCursorwordCurrent = { bg = "highlight_med", underline = false },

      MiniDiffOverAdd = { bg = "leaf" },
      MiniDiffOverChange = { bg = "gold" },
      MiniDiffOverDelete = { bg = "love" },

      LineNr = { fg = "muted" },
      CursorLineNr = { fg = "foam" },
      CursorLine = { bg = "overlay" },
    },
  },
}

-- Rose-pine palette
-- _nc = "#16141f",
-- base = "#191724",
-- surface = "#1f1d2e",
-- overlay = "#26233a",
-- muted = "#6e6a86",
-- subtle = "#908caa",
-- text = "#e0def4",
-- love = "#eb6f92",
-- gold = "#f6c177",
-- rose = "#ebbcba",
-- pine = "#31748f",
-- foam = "#9ccfd8",
-- iris = "#c4a7e7",
-- leaf = "#95b1ac",
-- highlight_low = "#21202e",
-- highlight_med = "#403d52",
-- highlight_high = "#524f67",
-- none = "NONE",
