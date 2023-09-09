local M = {}

-- A map of labels to commands.
local command_table = {}

-- A list of all the globally-registered commands.
local command_list = {}

-- Adds a command to our global list of commands.
local function add_command(command)
  if command == nil then
    return
  end

  -- Treat a string as the name of a command-module.
  if type(command) == "string" then
    M.add_commands(require("commanderly.commands." .. command))
    return
  end

  if type(command) ~= "table" then
    error("Type error: expected table, received " .. type(command) .. ".")
  end

  if command.id == nil and command.title == nil then
    error("Each command must have an id, or a title, or both.")
  end

  -- Don't mutate the caller's table.
  command = vim.deepcopy(command)

  -- Assign an ID if the command doesn't have one.
  if command.id == nil then
    command.id = command.title
  end

  -- Add the command to our list of all commands.
  table.insert(command_list, command)

  -- Add the command to our index, using both its id and its title.
  if type(command.id) == "string" then
    command_table[command.id] = command
  else
    error("Type error: command.id must be a string.")
  end

  -- A command's title property may be a function or a string.
  if type(command.title) == "string" then
    command_table[command.title] = command
  end
end

-- Adds all the commands to our global list of commands.
function M.add_commands(commands)
  if type(commands) == "string" then
    commands = { commands }
  end

  if commands.title ~= nil or commands.id ~= nil then
    add_command(commands)
  else
    for _, command in ipairs(commands) do
      add_command(command)
    end
  end
end

function M.get_command(s)
  return command_table[s]
end

function M.get_command_or_fail(s)
  local command = M.get_command(s)

  if command == nil then
    error("Command not found: " .. s)
  else
    return command
  end
end

function M.get_commands()
  return command_list
end

return M
