local commands = {
  -- Add command to toggle undotree.
  {
    title = "Toggle Undotree",
    desc = "View or hide the undotree for the current file.",
    mode = "n",
    alias = "UndotreeToggle",
  },

  -- Add command to toggle comments.
  {
    title = "Toggle Comment",
    desc = "Comment or uncomment current line.",
    mode = "n",
    run = function()
      require("Comment.api").toggle.linewise.current()
    end,
    requires = "Comment.api",
  },

  -- Add commands to toggle true zen-modes.
  {
    title = "Focus Current Window",
    desc = "Toggle zen-mode for focusing on the current window.",
    mode = "n",
    keywords = "zen mode focus",
    alias = "TZFocus",
    -- TODO: Add a requirement that there's more than one window.
  },
  {
    title = "Toggle Extra UI Elements",
    desc = "Hide or show extra UI elements like line numbers and the statusline.",
    mode = "n",
    keywords = "zen mode minimalist",
    alias = "TZMinimalist",
  },
  {
    title = "Toggle True Zen-Mode",
    desc = "Toggle zen-mode.",
    mode = "n",
    keywords = "zen mode ataraxis",
    alias = "TZAtaraxis",
  },

  -- Command to toggle Zen-Mode.
  {
    title = "Toggle Zen-Mode",
    desc = "Toggle zen-mode.",
    mode = "n",
    alias = "ZenMode",
  },

  -- Add commands to switch vscode colorschemes.
  {
    title = "Use Dark VSCode Colors",
    desc = "Use the dark VSCode colorscheme",
    mode = "n",
    keywords = "color scheme theme",
    run = function()
      require("vscode").change_style("dark")
    end,
    requires = "vscode",
  },
  {
    title = "Use Light VSCode Colors",
    desc = "Use the light VSCode colorscheme",
    mode = "n",
    keywords = "color scheme theme",
    run = function()
      require("vscode").change_style('light')
    end,
    requires = "vscode",
  },
}

return commands
