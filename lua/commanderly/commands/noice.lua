-- Commands for Noice.
-- Requires "folke/noice.nvim".

return {
  {
    title = "Show Message History",
    id = "noice_history",
    desc = "Open a window for viewing recent messages.",
    run = "Noice history",
    keywords = "noice",
  },
  {
    title = "Search Message History",
    id = "noice_telescope",
    desc = "Open a search window for searching recent messages.",
    run = "Noice telescope",
    keywords = "noice telescope",
  },
  {
    title = "Show Last Message",
    id = "noice_last",
    desc = "Show the last message in a popup window.",
    run = "Noice last",
    keywords = "noice",
  },
  {
    title = "Dismiss All Messages",
    id = "noice_dismiss",
    desc = "Clear all visible messages.",
    run = "Noice dismiss",
    keywords = "noice clear hide",
  },
  {
    title = "Show Errors",
    id = "noice_errors",
    desc = "Show recent error messages in a popup window.",
    run = "Noice errors",
    keywords = "noice",
  },
  {
    id = "toggle_noice",
    render = function()
      local noice_config = require("noice.config")
      if noice_config._running then
        return {
          title = "Disable Noice",
          desc = "Disable the Noice plugin.",
          run = "Noice disable",
          keywords = "noice plugin hide",
        }
      else
        return {
          title = "Enable Noice",
          desc = "Enable the Noice plugin.",
          run = "Noice enable",
          keywords = "noice plugin show",
        }
      end
    end,
  },
}
