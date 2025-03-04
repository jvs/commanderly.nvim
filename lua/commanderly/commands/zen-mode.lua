-- Simple command to toggle zen-mode.

-- TODO: Figure out how to tell if zen-mode is enabled or not.
return {
  {
    title = "Toggle Zen-Mode",
    id = "toggle_zen_mode",
    desc = "Toggle zen-mode.",
    requires = function()
      local has_zen_mode, _ = pcall(require, "zen-mode")
      return has_zen_mode
    end,
    run = function()
      require("commanderly.commands.lualine_utils").toggle()
      require("zen-mode").toggle()
    end,
  },
}
