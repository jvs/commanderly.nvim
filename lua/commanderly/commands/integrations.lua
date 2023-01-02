local commands = {
  -- Add commands to toggle lualine.
  {
    title = "Hide Status Line",
    desc = "Hide the lualine statusline.",
    run = function()
      require("lualine").hide()
    end,
    requires = function()
      -- TODO: Find out if there's a better way to tell if lualine is visible.
      local lualine_ok, _ = pcall(require, "lualine")
      return lualine_ok and string.find(vim.o.statusline, "lualine")
    end,
    keywords = "lualine",
  },
  {
    title = "Show Status Line",
    desc = "Show the lualine statusline.",
    run = function()
      require("lualine").hide({unhide=true})
    end,
    requires = function()
      -- TODO: Find out if there's a better way to tell if lualine is visible.
      local lualine_ok, _ = pcall(require, "lualine")
      return lualine_ok and not string.find(vim.o.statusline, "lualine")
    end,
    keywords = "lualine",
  },

  -- Add command to toggle undotree.
  {
    title = "Toggle Undotree",
    id = "undotree",
    desc = "View or hide the undotree for the current file.",
    alias = "UndotreeToggle",
  },

  -- Add command to toggle comments.
  {
    title = "Toggle Comment",
    desc = "Comment or uncomment current line.",
    run = function()
      require("Comment.api").toggle.linewise.current()
    end,
    requires = "Comment.api",
  },

  -- Add commands to toggle Neo-tree.
  {
    title = "Toggle Filesystem Explorer",
    id = "neotree_filesystem",
    desc = "Open a file browser and reveal the current file.",
    alias = "Neotree reveal toggle",
    keywords = "neo-tree",
  },
  {
    title = "Toggle Buffer Explorer",
    id = "neotree_buffers",
    desc = "Open a tree explorer of the current buffers.",
    alias = "Neotree buffers toggle",
    keywords = "neo-tree",
  },
  {
    title = "Toggle Git Status Explorer",
    id = "neotree_git_status",
    desc = "Open a tree explorer of the current git status.",
    alias = "Neotree git_status toggle",
    keywords = "neo-tree",
  },

  -- Add command to toggle Zen-Mode.
  {
    title = "Toggle Zen-Mode",
    desc = "Toggle zen-mode.",
    alias = "ZenMode",
  },

  -- Add commands to toggle true zen-modes.
  {
    title = "Focus Current Window",
    desc = "Toggle zen-mode for focusing on the current window.",
    keywords = "zen mode focus",
    alias = "TZFocus",
    -- TODO: Add a requirement that there's more than one window.
  },
  {
    title = "Toggle Extra UI Elements",
    desc = "Hide or show extra UI elements like line numbers and the statusline.",
    keywords = "zen mode minimalist",
    alias = "TZMinimalist",
  },
  {
    title = "Toggle True Zen-Mode",
    desc = "Toggle zen-mode.",
    keywords = "zen mode ataraxis",
    alias = "TZAtaraxis",
  },

  -- Add commands to switch vscode colorschemes.
  {
    title = "Use Dark VSCode Colors",
    desc = "Use the dark VSCode colorscheme",
    keywords = "color scheme theme",
    run = function()
      require("vscode").change_style("dark")
    end,
    requires = "vscode",
  },
  {
    title = "Use Light VSCode Colors",
    desc = "Use the light VSCode colorscheme",
    keywords = "color scheme theme",
    run = function()
      require("vscode").change_style('light')
    end,
    requires = "vscode",
  },

  -- Add format command.
  {
    title = "Format Current File",
    desc = "Automatically format the current file.",
    keywords = "lsp",
    alias = "Format",
  },
}

return commands
