local function has_lualine()
  local result, _ = pcall(require, "lualine")
  return result
end

local function is_place_visible(place)
  -- TODO: Find out if there's a better way to tell if lualine is visible.
  return string.find(vim.o[place], "lualine")
end

local function show_place(place)
  require("lualine").hide({ place = { place }, unhide = true })
end

local function hide_place(place)
  require("lualine").hide({ place = { place }, unhide = false })
end

local function show()
  require("lualine").hide({ place = { "statusline", "winbar" }, unhide = true })
end

local function hide()
  require("lualine").hide({ place = { "statusline", "winbar" }, unhide = false })
end

local function is_visible()
  return is_place_visible("statusline") or is_place_visible("winbar")
end

local function toggle()
  if is_visible() then
    hide()
  else
    show()
  end
end


M = {
  has_lualine = has_lualine,
  is_place_visible = is_place_visible,
  show_place = show_place,
  hide_place = hide_place,
  is_visible = is_visible,
  show = show,
  hide = hide,
  toggle = toggle,
}

return M
