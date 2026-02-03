return {
  "gruvw/strudel.nvim",
  -- Doesn't override filetypes if not loaded beforehand
  -- ft = { "str", "std" },
  event = "VeryLazy",
  build = "npm ci",
  opts = {
    ui = {
      -- Maximise the menu panel
      maximise_menu_panel = true,
      -- Hide the Strudel menu panel (and handle)
      hide_menu_panel = false,
      -- Hide the default Strudel top bar (controls)
      hide_top_bar = false,
      -- Hide the Strudel code editor
      hide_code_editor = false,
      -- Hide the Strudel eval error display under the editor
      hide_error_display = false,
    },
    -- Automatically start playback when launching Strudel
    start_on_launch = true,
    -- Set to `true` to automatically trigger the code evaluation after saving the buffer content
    update_on_save = false,
    -- Enable two-way cursor position sync between Neovim and Strudel editor
    sync_cursor = true,
    -- Report evaluation errors from Strudel as Neovim notifications
    report_eval_errors = true,
    custom_css_file = nil,
    -- Headless mode: set to `true` to run the browser without launching a window
    headless = false,
    -- Path to a (chromium-based) browser executable of choice
    -- browser_exec_path = "/path/to/browser/executable",
  },
  -- stylua: ignore start
  keys = {
    { "<leader>Ml", function() require("strudel").launch() end, desc = "Launch" },
    { "<leader>Mq", function() require("strudel").quit() end, desc = "Quit" },
    { "<leader>Mt", function() require("strudel").toggle() end, desc = "Toggle Play/Stop" },
    { "<leader>Mu", function() require("strudel").update() end, desc = "Update" },
    { "<leader>Ms", function() require("strudel").stop() end, desc = "Stop" },
    { "<leader>Mx", function() require("strudel").execute() end, desc = "Execute" },
  },
  -- stylua: ignore end
  init = function()
    require("which-key").add({
      { "<leader>M", group = "Strudel", icon = { icon = "", color = "purple" } },
    })

    local no_lsp_extensions = { "str", "std" }
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local bufname = vim.api.nvim_buf_get_name(args.buf)
        local ext = bufname:match("%.(%w+)$")
        if ext and vim.tbl_contains(no_lsp_extensions, ext) then
          vim.schedule(function()
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client then
              vim.lsp.buf_detach_client(args.buf, client.id)
            end
          end)
        end
      end,
    })
  end,
}
