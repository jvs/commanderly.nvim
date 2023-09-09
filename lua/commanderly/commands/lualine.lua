-- Commands for toggling lualine.
-- Requires 'nvim-lualine/lualine.nvim'.

local function is_visible(place)
  -- TODO: Find out if there's a better way to tell if lualine is visible.
  return string.find(vim.o[place], "lualine")
end


local function show(place)
  require("lualine").hide({place = {place}, unhide = false})
end


local function hide(place)
  require("lualine").hide({place = {place}, unhide = true})
end


return {
  {
    title = "Hide Lualine",
    desc = "Hide the lualine plugin.",
    run = function()
      require("lualine").hide()
    end,
    requires = function()
      return is_visible("statusline") or is_visible("winbar")
    end,
    keywords = "lualine",
  },

  {
    title = "Hide Status Line",
    desc = "Hide the lualine statusline.",
    run = function()
      hide("statusline")
    end,
    requires = function()
      return is_visible("statusline")
    end,
    keywords = "lualine",
  },

  {
    title = "Hide Winbar",
    desc = "Hide the lualine winbar.",
    run = function()
      hide("winbar")
    end,
    requires = function()
      return is_visible("winbar")
    end,
    keywords = "lualine",
  },

  {
    title = "Show Lualine",
    desc = "Show the lualine plugin.",
    run = function()
      require("lualine").hide({unhide = true})
    end,
    requires = function()
      return not is_visible("statusline") or not is_visible("winbar")
    end,
    keywords = "lualine",
  },

  {
    title = "Show Status Line",
    desc = "Show the lualine statusline.",
    run = function()
      show("statusline")
    end,
    requires = function()
      return not is_visible("statusline")
    end,
    keywords = "lualine",
  },

  {
    title = "Show Winbar",
    desc = "Show the lualine winbar.",
    run = function()
      show("winbar")
    end,
    requires = function()
      return not is_visible("winbar")
    end,
    keywords = "lualine",
  },
}
