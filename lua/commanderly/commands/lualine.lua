-- Commands for toggling lualine.
-- Requires 'nvim-lualine/lualine.nvim'.

local utils = require("commanderly.commands.lualine-utils")

return {
  {
    title = "Hide Lualine",
    id = "hide_lualine",
    desc = "Hide the lualine plugin.",
    requires = function()
      return utils.has_lualine() and utils.is_visible()
    end,
    run = function()
      utils.hide()
    end,
    keywords = "lualine",
  },

  {
    title = "Hide Status Line",
    desc = "Hide the lualine statusline.",
    requires = function()
      return utils.has_lualine() and utils.is_place_visible("statusline")
    end,
    run = function()
      utils.hide_place("statusline")
    end,
    keywords = "lualine",
  },

  {
    title = "Hide Winbar",
    desc = "Hide the lualine winbar.",
    requires = function()
      return utils.has_lualine() and utils.is_place_visible("winbar")
    end,
    run = function()
      utils.hide_place("winbar")
    end,
    keywords = "lualine",
  },

  {
    title = "Show Lualine",
    id = "show_lualine",
    desc = "Show the lualine plugin.",
    requires = function()
      return utils.has_lualine() and not utils.is_visible()
    end,
    run = function()
      utils.show()
    end,
    keywords = "lualine",
  },

  {
    title = "Show Status Line",
    desc = "Show the lualine statusline.",
    requires = function()
      return utils.has_lualine() and not utils.is_place_visible("statusline")
    end,
    run = function()
      utils.show_place("statusline")
    end,
    keywords = "lualine",
  },

  {
    title = "Show Winbar",
    desc = "Show the lualine winbar.",
    requires = function()
      return utils.has_lualine() and not utils.is_place_visible("winbar")
    end,
    run = function()
      utils.show_place("winbar")
    end,
    keywords = "lualine",
  },
}
