return {
  "rebelot/kanagawa.nvim",
  opts = {
    theme = "wave",
    transparent = false,
    compile = false,

    undercurl = true,
    commentStyle = { italic = false },
    functionStyle = { italic = false },
    keywordStyle = { italic = false },
    statementStyle = { italic = false },

    overrides = function(colors)
      local theme = colors.theme
      return {
        NormalFloat = { bg = "NONE", fg = "NONE" },
        FloatBorder = { bg = "NONE", fg = "NONE" },
        FloatTitle = { bg = "NONE", fg = "NONE" },

        -- Save an hlgroup with dark background and dimmed foreground
        -- so that you can use it where your still want darker windows.
        -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
        NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

        -- Popular plugins that open floats will link to NormalFloat by default;
        -- set their background accordingly if you wish to keep them dark and borderless
        LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

        DiagnosticUnnecessary = { fg = theme.syn.comment, bg = theme.ui.bg_m3, underline = true },
        DiagnosticSignInfo = { bg = "NONE" },
        DiagnosticSignWarn = { bg = "NONE" },
        DiagnosticSignError = { bg = "NONE" },
        DiagnosticSignHint = { bg = "NONE" },

        BlinkCmpLabel = { fg = theme.ui.fg_dim },
        BlinkCmpLabelMatch = { fg = theme.syn.keyword },

        HarpoonOptionHL = { fg = theme.ui.fg },
        HarpoonSelectedOptionHL = { fg = theme.syn.string },

        CodeCompanionChatTool = { fg = theme.syn.identifier },
        CodeCompanionChatVariable = { fg = theme.syn.identifier },

        MiniCursorword = { bg = theme.ui.bg_p2, underline = false },
        MiniCursorwordCurrent = { bg = theme.ui.bg_p2, underline = false },

        MiniDiffSignAdd = { bg = "NONE" },
        MiniDiffSignChange = { bg = "NONE" },
        MiniDiffSignDelete = { bg = "NONE" },

        MiniDiffOverAdd = { fg = theme.ui.bg, bg = theme.vcs.added },
        MiniDiffOverChange = { fg = theme.ui.bg, bg = theme.vcs.changed },
        MiniDiffOverDelete = { fg = theme.ui.bg, bg = theme.vcs.removed },

        LineNr = { fg = theme.ui.nontext, bg = "NONE" },
        CursorLineNr = { fg = theme.syn.fun },
        CursorLine = { bg = theme.ui.bg_p1 },
      }
    end,
  },
}

-- Kanagawa palette
-- -- Bg Shades
-- sumiInk0 = "#16161D",
-- sumiInk1 = "#181820",
-- sumiInk2 = "#1a1a22",
-- sumiInk3 = "#1F1F28",
-- sumiInk4 = "#2A2A37",
-- sumiInk5 = "#363646",
-- sumiInk6 = "#54546D",
--
-- -- Popup and Floats
-- waveBlue1 = "#223249",
-- waveBlue2 = "#2D4F67",
--
-- -- Diff and Git
-- winterGreen = "#2B3328",
-- winterYellow = "#49443C",
-- winterRed = "#43242B",
-- winterBlue = "#252535",
-- autumnGreen = "#76946A",
-- autumnRed = "#C34043",
-- autumnYellow = "#DCA561",
--
-- -- Diag
-- samuraiRed = "#E82424",
-- roninYellow = "#FF9E3B",
-- waveAqua1 = "#6A9589",
-- dragonBlue = "#658594",
--
-- -- Fg and Comments
-- oldWhite = "#C8C093",
-- fujiWhite = "#DCD7BA",
-- fujiGray = "#727169",
--
-- oniViolet = "#957FB8",
-- oniViolet2 = "#b8b4d0",
-- crystalBlue = "#7E9CD8",
-- springViolet1 = "#938AA9",
-- springViolet2 = "#9CABCA",
-- springBlue = "#7FB4CA",
-- lightBlue = "#A3D4D5", -- unused yet
-- waveAqua2 = "#7AA89F", -- improve lightness: desaturated greenish Aqua
--
-- -- waveAqua2  = "#68AD99",
-- -- waveAqua4  = "#7AA880",
-- -- waveAqua5  = "#6CAF95",
-- -- waveAqua3  = "#68AD99",
--
-- springGreen = "#98BB6C",
-- boatYellow1 = "#938056",
-- boatYellow2 = "#C0A36E",
-- carpYellow = "#E6C384",
--
-- sakuraPink = "#D27E99",
-- waveRed = "#E46876",
-- peachRed = "#FF5D62",
-- surimiOrange = "#FFA066",
-- katanaGray = "#717C7C",
--
-- dragonBlack0 = "#0d0c0c",
-- dragonBlack1 = "#12120f",
-- dragonBlack2 = "#1D1C19",
-- dragonBlack3 = "#181616",
-- dragonBlack4 = "#282727",
-- dragonBlack5 = "#393836",
-- dragonBlack6 = "#625e5a",
--
-- dragonWhite = "#c5c9c5",
-- dragonGreen = "#87a987",
-- dragonGreen2 = "#8a9a7b",
-- dragonPink = "#a292a3",
-- dragonOrange = "#b6927b",
-- dragonOrange2 = "#b98d7b",
-- dragonGray = "#a6a69c",
-- dragonGray2 = "#9e9b93",
-- dragonGray3 = "#7a8382",
-- dragonBlue2 = "#8ba4b0",
-- dragonViolet= "#8992a7",
-- dragonRed = "#c4746e",
-- dragonAqua = "#8ea4a2",
-- dragonAsh = "#737c73",
-- dragonTeal = "#949fb5",
-- dragonYellow = "#c4b28a",--"#a99c8b",
-- -- "#8a9aa3",
--
-- lotusInk1 = "#545464",
-- lotusInk2 = "#43436c",
-- lotusGray = "#dcd7ba",
-- lotusGray2 = "#716e61",
-- lotusGray3 = "#8a8980",
-- lotusWhite0 = "#d5cea3",
-- lotusWhite1 = "#dcd5ac",
-- lotusWhite2 = "#e5ddb0",
-- lotusWhite3 = "#f2ecbc",
-- lotusWhite4 = "#e7dba0",
-- lotusWhite5 = "#e4d794",
-- lotusViolet1 = "#a09cac",
-- lotusViolet2 = "#766b90",
-- lotusViolet3 = "#c9cbd1",
-- lotusViolet4 = "#624c83",
-- lotusBlue1 = "#c7d7e0",
-- lotusBlue2 = "#b5cbd2",
-- lotusBlue3 = "#9fb5c9",
-- lotusBlue4 = "#4d699b",
-- lotusBlue5 = "#5d57a3",
-- lotusGreen = "#6f894e",
-- lotusGreen2 = "#6e915f",
-- lotusGreen3 = "#b7d0ae",
-- lotusPink = "#b35b79",
-- lotusOrange = "#cc6d00",
-- lotusOrange2 = "#e98a00",
-- lotusYellow ="#77713f",
-- lotusYellow2 = "#836f4a",
-- lotusYellow3 = "#de9800",
-- lotusYellow4 = "#f9d791",
-- lotusRed = "#c84053",
-- lotusRed2 = "#d7474b",
-- lotusRed3 = "#e82424",
-- lotusRed4 = "#d9a594",
-- lotusAqua = "#597b75",
-- lotusAqua2 = "#5e857a",
-- lotusTeal1 = "#4e8ca2",
-- lotusTeal2 = "#6693bf",
-- lotusTeal3 = "#5a7785",
-- lotusCyan = "#d7e3d8",
