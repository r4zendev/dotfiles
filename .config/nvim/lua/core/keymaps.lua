local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })
map("n", "_", "o<ESC>", { noremap = true, silent = true })

map({ "n", "v" }, "<leader>cj", ":%!jq '.'<cr>", { desc = "Format JSON" })

map({ "n", "v" }, "<C-u>", "<C-u>zz", { noremap = true, silent = true })
map({ "n", "v" }, "<C-d>", "<C-d>zz", { noremap = true, silent = true })

map("v", ">", ">gv", { noremap = true, silent = true })
map("v", "<", "<gv", { noremap = true, silent = true })

map("n", "x", '"_x', { noremap = true, silent = true })

map("n", "<M-->", "<C-x>", { noremap = true, silent = true })
map("n", "<M-=>", "<C-a>", { noremap = true, silent = true })
map("v", "<M-->", "<C-x>gv", { noremap = true, silent = true })
map("v", "<M-=>", "<C-a>gv", { noremap = true, silent = true })
map({ "n", "v" }, "<C-a>", "<Nop>", { noremap = true, silent = true })
map({ "n", "v" }, "<C-x>", "<Nop>", { noremap = true, silent = true })

map({ "n", "v" }, "<Left>", "h", { noremap = true, silent = true })
map({ "n", "v" }, "<Down>", "j", { noremap = true, silent = true })
map({ "n", "v" }, "<Up>", "k", { noremap = true, silent = true })
map({ "n", "v" }, "<Right>", "l", { noremap = true, silent = true })

map("n", "<leader>yy", ':let @+ = expand("%:p")<CR>', { desc = "Copy buffer's path" })
map("n", "<leader>yr", ':let @+ = expand("%:.")<CR>', { desc = "Copy relative path" })
map("n", "<leader>pp", '"_cgn<C-r>"<Esc>', { desc = "Change next match with clipboard" }) -- (dot-repeatable)

map("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })

map("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close split" })
map("n", "<leader>wm", "<cmd>tab split<CR>", { desc = "Maximize split" })

map("n", "<leader>w=", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>wj", "<C-w>_", { desc = "Maximize split vertically" })
map("n", "<leader>wk", "<C-w>|", { desc = "Maximize split horizontally" })

map("n", "<leader>wH", "<C-w>H", { desc = "Move split to left" })
map("n", "<leader>wJ", "<C-w>J", { desc = "Move split to bottom" })
map("n", "<leader>wK", "<C-w>K", { desc = "Move split to top" })
map("n", "<leader>wL", "<C-w>L", { desc = "Move split to right" })

map("n", "<C-Left>", "5<C-w><", { desc = "Width shrink" })
map("n", "<C-Right>", "5<C-w>>", { desc = "Width grow" })
map("n", "<C-Up>", "5<C-w>+", { desc = "Height shrink" })
map("n", "<C-Down>", "5<C-w>-", { desc = "Height grow" })

vim.keymap.set("v", "<leader>[", function()
  vim.cmd('normal! "xy')
  local text = vim.fn.getreg("x")

  local font_dir = vim.fn.system("figlet -I2"):gsub("%s+$", "")
  local fonts = {}
  local files = vim.fn.globpath(font_dir, "*.flf", false, true)
  for _, f in ipairs(files) do
    local name = vim.fn.fnamemodify(f, ":t:r")
    table.insert(fonts, { text = name, name = name })
  end

  Snacks.picker.pick({
    title = "Figlet Font",
    items = fonts,
    layout = {
      preset = "select",
      layout = { width = 30, min_width = 25 },
    },
    format = function(item)
      return { { item.name } }
    end,
    confirm = function(picker, item)
      picker:close()
      if item then
        local result = vim.fn.system("figlet -f " .. item.name, text)
        vim.cmd('normal! gv"_c')
        local lines = vim.split(result, "\n", { trimempty = true })

        -- Automatically comment out the ASCII result (optional)
        --
        -- local cs = vim.bo.commentstring
        -- local prefix = cs:match("^(.-)%%s") or "# "
        --
        -- for i, line in ipairs(lines) do
        --   lines[i] = prefix .. line
        -- end
        --
        -- vim.cmd('normal! gv"_c')

        vim.api.nvim_put(lines, "c", false, true)
      end
    end,
  })
end, { desc = "Turn to ASCII art" })

vim.keymap.set("v", "<leader>]", function()
  vim.cmd('normal! "xy')

  local expr = vim.fn.getreg("x")
  local ok, result = pcall(function()
    return load("return " .. expr)()
  end)

  if ok then
    vim.cmd('normal! gv"_c' .. result)
  else
    vim.notify("Invalid expression", vim.log.levels.ERROR)
  end
end, { desc = "Evaluate selection as Lua" })

-- move in wrapped line, useful when vim.opt.wrap is set to true.
-- map("n", "k", function()
--   return vim.v.count == 0 and "gk" or "k"
-- end, { expr = true })
-- map("n", "j", function()
--   return vim.v.count == 0 and "gj" or "j"
-- end, { expr = true })
-- may break plugins if they rely on default j,k behavior.
-- in that case, it is better to map "gk" and "gj" to other keys:
-- keymap("n", "<Down>", "gj", { noremap = true, silent = true })
-- keymap("n", "<Up>", "gk", { noremap = true, silent = true })

-- repeat dot multiple times, didn't use that often.
-- map("n", "<leader>.", function()
--   return "<esc>" .. string.rep(".", vim.v.count1)
-- end, { expr = true, desc = "Repeat dot action" })

-- Search the web
--
-- local function search_web(engine, url_template)
--   vim.ui.input({ prompt = "Search " .. engine .. ": " }, function(query)
--     if query and query ~= "" then
--       local escaped = vim.uri_encode(query)
--       local url = url_template:format(escaped)
--       vim.ui.open(url)
--     end
--   end)
-- end
--
-- map("n", "<leader>go", function()
--   search_web("Google", "https://www.google.com/search?q=%s")
-- end, { desc = "Google it" })

-- Create a file adjacent to current buffer's location
--
-- map("n", "<leader>fn", function()
--   vim.ui.input({ prompt = "New file name: " }, function(filename)
--     if filename and filename:match("%S") then
--       vim.cmd("edit %:p:h/" .. vim.trim(filename))
--     end
--   end)
-- end, { desc = "Create new file" })
--

-- Print file's last modified time
--
-- map("n", "<leader>ym", function()
--   local path = vim.fn.expand("%:p")
--   local stat = vim.uv.fs_stat(path)
--
--   if stat then
--     vim.notify(string.format("Last modified: %s", os.date("%c", stat.mtime.sec)))
--   else
--     vim.notify("File not found.")
--   end
-- end, { desc = "Print file's last modified time" })
