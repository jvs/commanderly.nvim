return {
  -- indent
  {
    title = "Toggle Indent Lines",
    id = "snacks_toggle_indent_lines",
    desc = "Toggle indent lines.",
    run = function()
      local snacks = require('snacks')
      if snacks.indent.enabled then
        snacks.indent.disable()
      else
        snacks.indent.enable()
      end
    end,
    keywords = "indent snacks toggle",
  },

  -- picker
  {
    title = "Change colorscheme",
    id = "snacks_picker_colorscheme",
    desc = "Pick from the available color schemes.",
    run = function()
      require('snacks').picker.colorschemes()
    end,
    keywords = "pick color scheme theme snacks",
  },

  -- scratch
  {
    title = "Toggle Scratch Buffer",
    id = "snacks_scratch_toggle",
    desc = "Toggle scratch buffer.",
    run = function()
      require('snacks').scratch()
    end,
    keywords = "snacks scratch",
  },
  {
    title = "Select Scratch Buffer",
    id = "snacks_scratch_select",
    desc = "Select scratch buffer.",
    run = function()
      require('snacks').scratch.select()
    end,
    keywords = "snacks scratch",
  },

  -- zen
  {
    title = "Toggle Zen-Mode",
    id = "toggle_zen_mode",
    desc = "Toggle zen-mode.",
    -- TODO: Figure out how to tell if zen-mode is enabled or not.
    -- requires = function()
    --   local has_zen_mode, _ = pcall(require, "zen-mode")
    --   return has_zen_mode
    -- end,
    run = function()
      require("commanderly.commands.lualine-utils").toggle()
      require('snacks').zen()
    end,
  },
}
