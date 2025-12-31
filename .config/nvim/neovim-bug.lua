local strbuffer = require("vim._core.stringbuffer")

-- rpc.lua:73
local function get_content_length(header)
  local state = "name"
  local i, len = 1, #header
  local j, name = 1, "content-length"
  local buf = strbuffer.new()
  local digit = true
  while i <= len do
    local c = header:byte(i)
    if state == "name" then
      if c >= 65 and c <= 90 then -- lower case
        c = c + 32
      end
      if (c == 32 or c == 9) and j == 1 then -- luacheck: ignore 542
        -- skip OWS for compatibility only
      elseif c == name:byte(j) then
        j = j + 1
      elseif c == 58 and j == 15 then
        state = "colon"
      else
        state = "invalid"
      end
    elseif state == "colon" then
      if c ~= 32 and c ~= 9 then -- skip OWS normally
        state = "value"
        i = i - 1
      end
    elseif state == "value" then
      if c == 13 and header:byte(i + 1) == 10 then -- must end with \r\n
        local value = buf:get()
        return assert(digit and tonumber(value), "value of Content-Length is not number: " .. value)
      else
        buf:put(string.char(c))
      end
      if c < 48 and c ~= 32 and c ~= 9 or c > 57 then
        digit = false
      end
    elseif state == "invalid" then
      if c == 10 then -- reset for next line
        state, j = "name", 1
      end
    end
    i = i + 1
  end
  error("Content-Length not found in header: " .. header)
end

-- TODO: file a bug report to neovim
local header =
  "[35m🌼 daisyUI components 2.49.6\27[0m \27[0m https://daisyui.com\n  \27[32m✔︎ Including:\27[0m \27[0m base, components, 29 themes, utilities\n  \27[32m❤︎ Support daisyUI: \27[0m https://opencollective.com/daisyui \27[0m\n  \nContent-Length: 237\r\n"

print(get_content_length(header))
