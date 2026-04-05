local function has_copilot()
  return vim.fn.exists('*copilot#Enabled') == 1
end


local function is_copilot_enabled()
  return vim.fn['copilot#Enabled']() == 1
end


return {
  {
    title = "Disable Copilot",
    id = "disable_copilot",
    desc = "Disable the Copilot plugin.",
    requires = function()
      return has_copilot() and is_copilot_enabled()
    end,
    run = function()
      vim.cmd("Copilot disable")
      vim.notify("Copilot has been disabled.", vim.log.levels.INFO)
    end,
    keywords = "copilot",
  },

  {
    title = "Enable Copilot",
    id = "enable_copilot",
    desc = "Enable the Copilot plugin.",
    requires = function()
      return has_copilot() and not is_copilot_enabled()
    end,
    run = function()
      vim.cmd("Copilot enable")
      vim.notify("Copilot has been enabled.", vim.log.levels.INFO)
    end,
    keywords = "copilot",
  },

  {
    title = "Select Copilot Model",
    id = "select_copilot_model",
    desc = "Select the Copilot model to use.",
    requires = function()
      return has_copilot()
    end,
    run = function()
      vim.cmd("Copilot model")
    end,
    keywords = "copilot",
  },
}
