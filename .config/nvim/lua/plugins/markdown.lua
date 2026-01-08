return {
  {
    "jghauser/follow-md-links.nvim",
    ft = "markdown",
    opts = {},
  },
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    cmd = "Markview",
    opts = {},
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>pm", vim.cmd.MarkdownPreview, desc = "Preview Markdown" },
    },
  },
  {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    cmd = {
      "Obsidian",
      "ObsidianOpen",
      "ObsidianSearch",
      "ObsidianQuickSwitch",
      "ObsidianLinks",
      "ObsidianBacklinks",
      "ObsidianTags",
      "ObsidianTemplate",
      "ObsidianDailies",
      "ObsidianTOC",
      "ObsidianRename",
      "ObsidianPasteImg",
      "ObsidianExtractNote",
      "ObsidianLink",
      "ObsidianLinkNew",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        { name = "main", path = "~/vault/main" },
      },

      -- notes_subdir = "notes",

      picker = {
        name = "snacks.picker",
        note_mappings = {
          new = "<C-n>",
        },
      },

      search = {
        sort_by = "modified",
        sort_reversed = true,
      },

      open_notes_in = "vsplit",

      log_level = vim.log.levels.INFO,

      -- disable_frontmatter = true,

      wiki_link_func = "prepend_note_id",
      -- wiki_link_func = "use_alias_only",
      -- wiki_link_func = "prepend_note_path",
      -- wiki_link_func = "use_path_only",

      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

      new_notes_location = "notes_subdir",

      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
        substitutions = {},
      },

      daily_notes = {
        date_format = "%Y-%m-%d",
        folder = "notes/daily",
        alias_format = "%A %B %d, %Y",
        template = "daily.md",
      },

      ---@param note obsidian.Note
      frontmatter = {
        func = function(note)
          -- Add the title of the note as an alias.
          if note.title then
            note:add_alias(note.title)
          end

          local out = { id = note.id, aliases = note.aliases, tags = note.tags }

          -- `note.metadata` contains any manually added fields in the frontmatter.
          -- So here we just make sure those fields are kept in the frontmatter.
          if note.metadata ~= nil and vim.tbl_count(note.metadata) > 0 then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end
          return out
        end,
      },

      attachments = {
        img_name_func = function()
          ---@type obsidian.Client
          local client = require("obsidian").get_client()

          local note = client:current_note()
          if note then
            return string.format("%s-", note.id)
          else
            return string.format("%s-", os.time())
          end
        end,
      },

      checkbox = {
        order = { " ", "x", ">", "!", "~", "?" },
      },
    },
    config = function(_, opts)
      -- Setup obsidian.nvim
      require("obsidian").setup(opts)

      -- Create which-key mappings for common commands.
      local wk = require("which-key")

      wk.add({
        { "<leader>o", group = "Obsidian" },
        { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open note" },
        { "<leader>od", "<cmd>ObsidianDailies -10 0<cr>", desc = "Daily notes" },
        { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image" },
        { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch" },
        { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search" },
        { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Tags" },
        { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Links" },
        { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
        { "<leader>om", "<cmd>ObsidianTemplate<cr>", desc = "Template" },
        { "<leader>on", "<cmd>ObsidianQuickSwitch nav<cr>", desc = "Nav" },
        { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename" },
        { "<leader>oc", "<cmd>ObsidianTOC<cr>", desc = "Contents (TOC)" },
        {
          "<leader>ow",
          function()
            local Note = require("obsidian.note")
            ---@type obsidian.Client
            local client = require("obsidian").get_client()
            assert(client)

            local picker = client:picker()
            if not picker then
              client.log.err("No picker configured")
              return
            end

            ---@param dt number
            ---@return obsidian.Path
            local function weekly_note_path(dt)
              return client.dir / os.date("notes/weekly/week-of-%Y-%m-%d.md", dt)
            end

            ---@param dt number
            ---@return string
            local function weekly_alias(dt)
              local alias = os.date("Week of %A %B %d, %Y", dt)
              assert(type(alias) == "string")
              return alias
            end

            local day_of_week = os.date("%A")
            assert(type(day_of_week) == "string")

            ---@type integer
            local offset_start
            if day_of_week == "Sunday" then
              offset_start = 1
            elseif day_of_week == "Monday" then
              offset_start = 0
            elseif day_of_week == "Tuesday" then
              offset_start = -1
            elseif day_of_week == "Wednesday" then
              offset_start = -2
            elseif day_of_week == "Thursday" then
              offset_start = -3
            elseif day_of_week == "Friday" then
              offset_start = -4
            elseif day_of_week == "Saturday" then
              offset_start = 2
            end
            assert(offset_start)

            local current_week_dt = os.time() + (offset_start * 3600 * 24)
            ---@type obsidian.PickerEntry
            local weeklies = {}
            for week_offset = 0, -2, -1 do
              local week_dt = current_week_dt + (week_offset * 3600 * 24 * 7)
              local week_alias = weekly_alias(week_dt)
              local week_display = week_alias
              local path = weekly_note_path(week_dt)

              if week_offset == 0 then
                week_display = week_display .. " @current"
              elseif week_offset == 1 then
                week_display = week_display .. " @next"
              elseif week_offset == -1 then
                week_display = week_display .. " @last"
              end

              if not path:is_file() then
                week_display = week_display .. " ➡️ create"
              end

              weeklies[#weeklies + 1] = {
                value = week_dt,
                display = week_display,
                ordinal = week_display,
                filename = tostring(path),
              }
            end

            picker:pick(weeklies, {
              prompt_title = "Weeklies",
              callback = function(dt)
                local path = weekly_note_path(dt)
                ---@type obsidian.Note
                local note
                if path:is_file() then
                  note = Note.from_file(path)
                else
                  note = client:create_note({
                    id = path.name,
                    dir = path:parent(),
                    title = weekly_alias(dt),
                    tags = { "weekly-notes" },
                  })
                end
                client:open_note(note)
              end,
            })
          end,
          desc = "Weeklies",
        },
        {
          mode = { "v" },
          -- { "<leader>o", group = "Obsidian" },
          {
            "<leader>oe",
            function()
              local title = vim.fn.input({ prompt = "Enter title (optional): " })
              vim.cmd("ObsidianExtractNote " .. title)
            end,
            desc = "Extract text into new note",
          },
          {
            "<leader>ol",
            function()
              vim.cmd("ObsidianLink")
            end,
            desc = "Link text to an existing note",
          },
          {
            "<leader>on",
            function()
              vim.cmd("ObsidianLinkNew")
            end,
            desc = "Link text to a new note",
          },
          {
            "<leader>ot",
            function()
              vim.cmd("ObsidianTags")
            end,
            desc = "Tags",
          },
        },
      })
    end,
  },
}
