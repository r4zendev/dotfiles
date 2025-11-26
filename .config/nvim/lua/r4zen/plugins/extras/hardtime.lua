return {
  "m4xshen/hardtime.nvim",
  event = "LazyFile",
  opts = {
    disable_mouse = false,
    restriction_mode = "hint",
    hints = {
      ["d[tTfF].i"] = { -- this matches d + {t/T/f/F} + {any character} + i
        message = function(keys) -- keys is a string of key strokes that matches the pattern
          return "Use " .. "c" .. keys:sub(2, 3) .. " instead of " .. keys
          -- example: Use ct( instead of dt(i
        end,
        length = 4,
      },
      ["[dcyvV][ia][%(%)]"] = {
        message = function(keys)
          return "Use " .. keys:sub(1, 2) .. "b instead of " .. keys
        end,
        length = 3,
      },
      ["[dcyvV][ia][%{%}]"] = {
        message = function(keys)
          return "Use " .. keys:sub(1, 2) .. "B instead of " .. keys
        end,
        length = 3,
      },
    },
  },
}
