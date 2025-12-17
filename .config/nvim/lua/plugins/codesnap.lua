return {
  "mistricky/codesnap.nvim",
  cmd = {
    "CodeSnap",
    "CodeSnapSave",
    "CodeSnapHighlight",
    "CodeSnapSaveHighlight",
    "CodeSnapASCII",
  },
  opts = {
    show_line_number = true,
    highlight_color = "#ffffff20",
    show_workspace = true,
    snapshot_config = {
      theme = "candy",
      window = {
        mac_window_bar = true,
        shadow = {
          radius = 20,
          color = "#00000040",
        },
        margin = {
          x = 62,
          y = 42,
        },
        border = {
          width = 1,
          color = "#ffffff30",
        },
        title_config = {
          color = "#ffffff",
          font_family = "Pacifico",
        },
      },
      themes_folders = {},
      fonts_folders = {},
      line_number_color = "#495162",
      command_output_config = {
        prompt = "❯",
        font_family = "CaskaydiaCove Nerd Font",
        prompt_color = "#F78FB3",
        command_color = "#98C379",
        string_arg_color = "#ff0000",
      },
      code_config = {
        font_family = "CaskaydiaCove Nerd Font",
        breadcrumbs = {
          enable = true,
          separator = "/",
          color = "#80848b",
          font_family = "CaskaydiaCove Nerd Font",
        },
      },
      -- watermark = {
      --   content = "CodeSnap.nvim",
      --   font_family = "Pacifico",
      --   color = "#ffffff",
      -- },
      -- background = "#00000000",
      watermark = {
        content = "",
      },
      background = {
        start = {
          x = 0,
          y = 0,
        },
        ["end"] = {
          x = "max",
          y = "max",
        },
        stops = {
          {
            position = 0,
            color = "#EBECB2",
          },
          {
            position = 0.28,
            color = "#F3B0F7",
          },
          {
            position = 0.73,
            color = "#92B5F0",
          },
          {
            position = 0.94,
            color = "#AEF0F8",
          },
        },
      },
      -- background = {
      --   start = {
      --     x = 0,
      --     y = 0,
      --   },
      --   ["end"] = {
      --     x = "max",
      --     y = 0,
      --   },
      --   stops = {
      --     {
      --       position = 0,
      --       color = "#6bcba5",
      --     },
      --     {
      --       position = 1,
      --       color = "#caf4c2",
      --     },
      --   },
      -- },
    },
  },
}
