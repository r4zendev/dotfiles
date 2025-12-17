return {
  "codethread/qmk.nvim",
  cmd = { "QMKFormat" },
  ---@type qmk.UserConfig
  opts = {
    name = "LAYOUT_split_3x6_3",
    comment_preview = {
      keymap_overrides = {
        -- One-shot mods
        ["OSM%(MOD_LGUI%)"] = "⌘⇧",
        ["OSM%(MOD_LALT%)"] = "⌥⇧",
        ["OSM%(MOD_LCTL%)"] = "⌃⇧",
        ["OSM%(MOD_LSFT%)"] = "⇧⇧",

        -- Mouse keys
        MS_WHLU = "↑◎",
        MS_WHLD = "↓◎",
        MS_WHLL = "←◎",
        MS_WHLR = "→◎",
        MS_LEFT = "←☍",
        MS_RGHT = "→☍",
        MS_UP = "↑☍",
        MS_DOWN = "↓☍",
        MS_BTN1 = "👉1",
        MS_BTN2 = "👉2",
        MS_BTN3 = "👉3",

        -- Media keys
        KC_MPRV = "⏮️",
        KC_MNXT = "⏭️",
        KC_MPLY = "⏯️",
        KC_VOLU = "🔊",
        KC_VOLD = "🔉",
        KC_MUTE = "🔇",

        -- Special keys
        KC_TRNS = "▼",
        KC_NO = "✕",
        KC_SPC = "␣",
        KC_ENT = "⏎",
        KC_ESC = "⎋",
        KC_BSPC = "⌫",
        KC_DEL = "⌦",
        KC_TAB = "⇥",
        KC_SLEP = "💤",
        KC_PSCR = "🖼️",

        -- Modifiers
        LSFT = "⇧",
        LCTL = "⌃",
        LALT = "⌥",
        LGUI = "⌘",

        -- Modifier combinations
        ["LCTL%(KC_LEFT%)"] = "⌃←",
        ["LCTL%(KC_RGHT%)"] = "⌃→",
        ["LGUI%(KC_LCBR%)"] = "⌘{",
        ["LGUI%(KC_RCBR%)"] = "⌘}",
        ["LCTL%(KC_SPC%)"] = "⌃␣",
        ["LALT%(KC_BSPC%)"] = "⌥⌫",
        ["LALT%(KC_LEFT%)"] = "⌥←",
        ["LALT%(KC_RGHT%)"] = "⌥→",
        ["LGUI%(KC_LEFT%)"] = "⌘←",
        ["LGUI%(KC_RGHT%)"] = "⌘→",
        ["LGUI%(KC_TAB%)"] = "⌘⇥",
        ["LGUI%(KC_S%)"] = "⌘S",
        ["LGUI%(KC_Z%)"] = "⌘Z",
        ["LGUI%(KC_X%)"] = "⌘X",
        ["LGUI%(KC_C%)"] = "⌘C",
        ["LGUI%(KC_V%)"] = "⌘V",
        ["LGUI%(KC_A%)"] = "⌘A",
        ["LGUI%(KC_Q%)"] = "⌘Q",
      },
    },
    layout = {
      "x x x x x x _ x x x x x x",
      "x x x x x x _ x x x x x x",
      "x x x x x x _ x x x x x x",
      "_ _ _ x x x _ x x x _ _ _",
    },
  },
}
