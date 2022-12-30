local commands = {}

local exists = function(command)
  return vim.fn.exists(":" .. command) > 0
end


-- Add command for toggling the undotree.
if exists("UndotreeToggle") then
  table.insert(commands, {
    title = "Toggle Undotree",
    desc = "View or hide the undotree for the current file.",
    mode = "n",
    alias = "UndotreeToggle",
  })
end


-- Add command to comment or uncomment the current line.
local has_comment, comment_api = pcall(require, "Comment.api")
if has_comment then
  table.insert(commands, {
      title = "Toggle Comment",
      desc = "Comment or uncomment current line.",
      mode = "n",
      run = function()
        comment_api.toggle.linewise.current()
      end,
  })
end


-- Add commands for true-zen modes.
if exists("TZFocus") then
  table.insert(commands, {
    title = "Focus Current Window",
    desc = "Toggle zen-mode for focusing on the current window.",
    mode = "n",
    keywords = "zen mode",
    alias = "TZFocus",
  })
end


if exists("TZMinimalist") then
  table.insert(commands, {
    title = "Toggle UI Elements",
    desc = "Hide or show extra UI elements like line numbers and the statusline.",
    mode = "n",
    keywords = "zen mode",
    alias = "TZMinimalist",
  })
end


if exists("TZAtaraxis") then
  table.insert(commands, {
    title = "Toggle Zen-Mode",
    desc = "Toggle zen-mode.",
    mode = "n",
    keywords = "zen mode",
    alias = "TZAtaraxis",
  })
end


-- Add commands for vscode.nvim.
local has_vscode, vscode = pcall(require, "vscode")
if has_vscode then
  table.insert(commands, {
    title = "Use Dark VSCode Colors",
    desc = "Use the dark VSCode colorscheme",
    mode = "n",
    keywords = "color scheme theme",
    run = function()
      vscode.change_style('dark')
    end
  })

  table.insert(commands, {
    title = "Use Light VSCode Colors",
    desc = "Use the light VSCode colorscheme",
    mode = "n",
    keywords = "color scheme theme",
    run = function()
      vscode.change_style('light')
    end
  })
end

return commands
