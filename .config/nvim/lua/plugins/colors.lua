return {
  {
    "catgoose/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = {
      filetypes = { "*", "!oil", "!snacks_picker_input" },
      buftypes = {},
      lazy_load = true,
      user_default_options = {
        -- names, RGB, RGBA, RRGGBB, RRGGBBAA, AARRGGBB, rgb_fn, hsl_fn, oklch_fn
        css = true,
        -- rgb_fn, hsl_fn, oklch_fn
        css_fn = true,
        -- Tailwind colors.  boolean|'normal'|'lsp'|'both'.  True sets to 'normal'
        tailwind = "both",
        tailwind_opts = {
          update_names = true,
        },
      },
    },
  },
  {
    "uga-rosa/ccc.nvim",
    event = "LazyFile",
    cmd = {
      "CccPick",
      "CccConvert",
      "CccHighlighterDisable",
      "CccHighlighterEnable",
      "CccHighlighterToggle",
    },
    opts = {
      highlighter = {
        auto_enable = false,
        filetypes = {
          "css",
          "javascript",
          "typescript",
          "typescriptreact",
          "javascriptreact",
          "vue",
          "html",
          "dbout",
          "sql",
          "lua",
        },
      },
    },
    keys = {
      { "<leader>pc", vim.cmd.CccPick, desc = "Pick color" },
    },
    -- NOTE: for reference
    -- config = function(_, opts)
    --   local ccc = require("ccc")
    --
    --   local mapping = ccc.mapping
    --   local utils = require("ccc.utils")
    --
    --   ccc.setup(vim.tbl_extend("force", opts, {
    --     mappings = {
    --       ["<CR>"] = mapping.complete,
    --       ["q"] = mapping.quit,
    --       ["l"] = mapping.increase1,
    --       ["d"] = mapping.increase5,
    --       [","] = mapping.increase10,
    --       ["h"] = mapping.decrease1,
    --       ["s"] = mapping.decrease5,
    --       ["m"] = mapping.decrease10,
    --       ["H"] = mapping.set0,
    --       ["M"] = mapping.set50,
    --       ["L"] = mapping.set100,
    --       ["0"] = mapping.set0,
    --       ["1"] = utils.bind(mapping._set_percent, 10),
    --       ["2"] = utils.bind(mapping._set_percent, 20),
    --       ["3"] = utils.bind(mapping._set_percent, 30),
    --       ["4"] = utils.bind(mapping._set_percent, 40),
    --       ["5"] = mapping.set50,
    --       ["6"] = utils.bind(mapping._set_percent, 60),
    --       ["7"] = utils.bind(mapping._set_percent, 70),
    --       ["8"] = utils.bind(mapping._set_percent, 80),
    --       ["9"] = utils.bind(mapping._set_percent, 90),
    --       ["r"] = mapping.reset_mode,
    --       ["a"] = mapping.toggle_alpha,
    --       ["g"] = mapping.toggle_prev_colors,
    --       ["b"] = mapping.goto_prev,
    --       ["w"] = mapping.goto_next,
    --       ["B"] = mapping.goto_head,
    --       ["W"] = mapping.goto_tail,
    --       ["i"] = mapping.cycle_input_mode,
    --       ["o"] = mapping.cycle_output_mode,
    --       ["<LeftMouse>"] = mapping.click,
    --       ["<ScrollWheelDown>"] = mapping.decrease1,
    --       ["<ScrollWheelUp>"] = mapping.increase1,
    --     },
    --   }))
    -- end,
  },
  {
    -- Only this plugin supports ALL the variants below. But I don't like how its colorpicker looks.
    "eero-lehtinen/oklch-color-picker.nvim",
    event = "VeryLazy",
    enabled = false,
    version = "*",
    keys = {
      {
        "<leader>v",
        function()
          require("oklch-color-picker").pick_under_cursor()
        end,
        desc = "Color pick under cursor",
      },
    },
    ---@type oklch.Opts
    opts = {},
  },
}

-- #RGB #e44
-- #RGBA #f717
-- #RRGGBB #f59e0b
-- #RRGGBBAA #eab30877
-- 0XRRGGBB 0x84CC16
-- OXAARRGGBB 0x7722C55E
-- css rgb rgb(16 185 129)
-- css hsl(173.41 0.8039 0.4)
-- css oklch(0.7148 0.1257 215.22)
-- tailwind bg-sky-500
--
-- ```js
-- let a = color(99, 182, 241, 255);
-- let b = floatColor(0.55, 0.36, 0.96, 0.50);
-- ```
