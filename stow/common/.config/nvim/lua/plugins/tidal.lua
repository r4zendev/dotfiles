return {
  "thgrund/tidal.nvim",
  pin = true, -- has local marker.lua fix
  ft = { "tidal" },
  opts = {
    --- Configure TidalLaunch command
    boot = {
      tidal = {
        --- Command to launch ghci with tidal installation
        cmd = "ghci",
        args = { "-v0" },
        --- Custom boot file with editor target for event highlighting (tidal 1.9.5 compatible)
        file = vim.fn.expand("~/.config/tidal/BootTidal.hs"),
        enabled = true,
        highlight = {
          autostart = false,
          styles = {
            osc = {
              ip = "127.0.0.1",
              port = 3335,
            },
            -- [Tidal ID] -> hl style
            custom = {
              ["drums"] = { bg = "#e7b9ed", foreground = "#000000" },
              ["2"] = { bg = "#b9edc7", foreground = "#000000" },
            },
            global = {
              baseName = "CodeHighlight",
              style = { bg = "#7eaefc", foreground = "#000000" },
            },
          },
          events = {
            osc = {
              ip = "127.0.0.1",
              port = 6013,
            },
          },
          fps = 30,
        },
      },
      sclang = {
        --- Command to launch SuperCollider
        cmd = "sclang",
        args = {},
        --- SuperCollider boot file
        file = vim.api.nvim_get_runtime_file("bootfiles/BootSuperDirt.scd", false)[1],
        enabled = true,
      },
      split = "v",
    },
    --- Default keymaps
    --- Set to false to disable all default mappings
    --- @type table | nil
    mappings = {
      send_line = { mode = { "i", "n" }, key = "<leader>Te" },
      send_visual = { mode = { "x" }, key = "<leader>Te" },
      send_block = { mode = { "i", "n", "x" }, key = "<leader>Tb" },
      send_node = { mode = "n", key = "<leader>Tn" },
      send_silence = { mode = "n", key = "<leader>Td" },
      send_hush = { mode = "n", key = "<leader>TH" },
    },
    ---- Configure highlight applied to selections sent to tidal interpreter
    selection_highlight = {
      --- Highlight definition table
      --- see ':h nvim_set_hl' for details
      --- @type vim.api.keyset.highlight
      highlight = { link = "IncSearch" },
      --- Duration to apply the highlight for
      timeout = 150,
    },
  },
  keys = {
    { "<leader>Tl", "<cmd>TidalLaunch<cr>", desc = "Launch" },
    { "<leader>Tq", "<cmd>TidalQuit<cr>", desc = "Quit" },
    { "<leader>Th", "<cmd>TidalStartEventHighlighting<cr>", desc = "Start event highlighting" },
    { "<leader>Tk", "<cmd>TidalStopEventHighlighting<cr>", desc = "Stop event highlighting" },
    { "<leader>To", "<cmd>TidalNotification<cr>", desc = "Tidal output" },
    { "<leader>Ts", "<cmd>SuperColliderNotification<cr>", desc = "SuperCollider output" },
  },
  init = function()
    require("which-key").add({
      { "<leader>T", group = "Tidal", icon = { icon = "♫", color = "purple" } },
    })
  end,
}
