-- Commands for toggling lualine.
-- Requires 'nvim-lualine/lualine.nvim'.

local has_lualine, _ = pcall(require, "lualine")

if not has_lualine then
  return {}
end

local utils = require("commanderly.commands.lualine-utils")

return {
  {
    title = "Hide Lualine",
    id = "hide_lualine",
    desc = "Hide the lualine plugin.",
    requires = function()
      return utils.is_lualine_visible()
    end,
    run = utils.hide_lualine,
    keywords = "lualine",
  },

  {
    title = "Hide Status Line",
    id = "hide_statusline",
    desc = "Hide the lualine statusline.",
    requires = function()
      return utils.is_statusline_visible()
    end,
    run = utils.hide_statusline,
    keywords = "lualine",
  },

  {
    title = "Hide Winbar",
    id = "hide_winbar",
    desc = "Hide the lualine winbar.",
    requires = utils.is_winbar_visible,
    run = utils.hide_winbar,
    keywords = "lualine",
  },

  {
    title = "Show Lualine",
    id = "show_lualine",
    desc = "Show the lualine plugin.",
    requires = function()
      return not utils.is_lualine_visible()
    end,
    run = utils.show_lualine,
    keywords = "lualine",
  },

  {
    title = "Show Status Line",
    desc = "Show the lualine statusline.",
    requires = function()
      return not utils.is_statusline_visible()
    end,
    run = utils.show_statusline,
    keywords = "lualine",
  },

  {
    title = "Show Winbar",
    desc = "Show the lualine winbar.",
    requires = function()
      return not utils.is_winbar_visible()
    end,
    run = utils.show_winbar,
    keywords = "lualine",
  },

  -- Statusline configuration

  {
    title = "Show Custom Status Line",
    desc = "Show this configuration's statusline.",
    requires = function()
      return not utils.has_custom_statusline()
    end,
    run = utils.show_custom_statusline,
    keywords = "lualine",
  },

  {
    title = "Show Default Status Line",
    desc = "Show the default lualine statusline.",
    requires = function()
      return not utils.has_default_statusline()
    end,
    run = utils.show_default_statusline,
    keywords = "lualine",
  },

  {
    title = "Show Simple Status Line",
    id = "show_simple_statusline",
    desc = "Show a simplified lualine statusline.",
    requires = function()
      return not utils.has_simple_statusline()
    end,
    run = utils.show_simple_statusline,
    keywords = "lualine",
  },

}
