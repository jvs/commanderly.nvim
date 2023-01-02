local M = {}

-- A map of labels to commands.
local command_index = {}

-- A list of all the globally-registered commands.
local command_list = {}

-- A table of all the keymappings.
local keymappings = {}

local function create_key(s)
  return s:gsub("[^a-zA-Z0-9_]", "_"):lower()
end

local function add_command(command)
  if command.id == nil and command.title == nil then
    error("Each command must have an id, or a title, or both.")
  end

  -- Don't mutate the caller's table.
  command = vim.deepcopy(command)

  -- Assign an ID if the command doesn't have one.
  if command.id == nil then
    command.id = create_key(command.title)
  end

  -- Add the command to our list of all commands.
  table.insert(command_list, command)

  -- Add the command to our index, using both its id and its title.
  if type(command.id) == "string" then
    command_index[create_key(command.id)] = command
  end

  if type(command.title) == "string" then
    command_index[create_key(command.title)] = command
  end

  if command.keymapping ~= nil then
    M.map(command.keymapping, command, command.opts)
  end
end

function M.add_commands(commands)
  if commands.title ~= nil or commands.id ~= nil then
    add_command(commands)
  else
    for _, command in pairs(commands) do
      add_command(command)
    end
  end
end

function M.map(keys, command, opts)
  opts = vim.deepcopy(opts or {})

  local command_info
  if type(command) == "string" then
    command_info = M.get_command(command)
  else
    command_info = command
  end

  local has_info = (type(command_info) == "table")

  local command_key
  if has_info then
    command_key = create_key(command_info.id)
  else
    command_key = create_key(command)
  end

  local mode = opts.mode

  if mode == nil and has_info then
    mode = command_info.mode
  end

  if mode == nil then
    mode = "n"
  end

  if opts.desc == nil and has_info then
    opts.desc = command_info.desc
  end

  local run = function()
    M.run(command)
  end
  vim.keymap.set(mode, keys, run, opts)

  -- Record this keymapping in our table of all the keymappings.
  local found_mappings = keymappings[command_key]
  if found_mappings == nil then
    keymappings[command_key] = { keys }
  else
    table.insert(found_mappings, keys)
  end
end

function M.get_command(s)
  return command_index[create_key(s)]
end

local function get_command_or_fail(s)
  local command = M.get_command(s)

  if command == nil then
    error("Command not found: " .. s)
  end

  return command
end

function M.run(command)
  if type(command) == "string" then
    command = get_command_or_fail(command)
  end

  local alias = command.alias
  local run = command.run

  if type(run) == "function" then
    run()
  elseif type(run) == "string" then
    local keys = vim.api.nvim_replace_termcodes(run, true, false, true)
    vim.api.nvim_feedkeys(keys, "t", true)
  elseif type(alias) == "string" then
    vim.cmd(alias)
  else
    error('Invalid command. Expected "alias" or "run", received: ' .. command)
  end
end

function M.setup(opts)
  local modules = {
    "core",
    "integrations",
    "telescope",
  }

  for _, name in pairs(modules) do
    local module_name = "commanderly.commands." .. name
    M.add_commands(require(module_name))
  end

  require("telescope").load_extension("commanderly")
end

function M.open(line1, line2)
  -- TODO: Pass line1 and line2 to commanderly extension.
  require("telescope").extensions.commanderly.commanderly()
end

local function has_requirement(requirement)
  -- A requirement can be a string, a function, a table, or nil.
  if requirement == nil then
    return true

  -- If it's a string, then interpret it as the name of a lua module.
  elseif type(requirement) == "string" then
    local is_ok, _ = pcall(require, requirement)
    return is_ok

  -- If it's a function, then treat it as a boolean-valued function.
  elseif type(requirement) == "function" then
    return requirement()

  -- If it's a table, then treat it as a list of requirements.
  elseif type(requirement) == "table" then
    for _, item in pairs(requirement) do
      if not has_requirement(item) then
        return false
      end
    end
    return true
  end

  error("Unexpected requirement: " .. type(requirement))
end

local function is_available(command)
  if command == nil or command.title == nil or command.hidden then
    return false
  elseif not has_requirement(command.requires) then
    return false
  elseif command.alias ~= nil then
    local head = command.alias:gsub("%s.*", "")
    local has_alias = vim.fn.exists(":" .. head) > 0

    if not has_alias then
      return false
    end
  end

  return true
end

local function get_keymapping(command)
  if command.keymapping ~= nil then
    return command.keymapping
  end

  local result = keymappings[create_key(command.id)]

  if result ~= nil then
    return result
  elseif type(command.title) == "string" then
    return keymappings[create_key(command.title)]
  else
    return nil
  end
end

local function render_keymapping(keymapping)
  if keymapping == nil then
    return nil
  end

  local result
  for _, keys in pairs(keymapping) do
    if result == nil or #result >= #keys then
      result = keys
    end
  end
  return result
end

local function render_shortcut(command)
  local shortcut = render_keymapping(command.keymapping)

  if shortcut ~= nil then
    return shortcut
  elseif type(command.alias) == "string" then
    return ":" .. command.alias
  elseif type(command.run) == "string" then
    return command.run
  end

  return nil
end

local function render(command)
  -- Look up the keymapping before rendering the command.
  local keymapping = get_keymapping(command)

  -- Call the command's render function.
  if type(command.render) == "function" then
    command = command.render()
  end

  -- Create a deepcopy so that we don't mutate the command.
  local result = vim.deepcopy(command)

  -- Assign the keymapping if we don't have one yet.
  if result.keymapping == nil then
    result.keymapping = keymapping
  end

  -- Render the title if it's a function.
  if type(result.title) == "function" then
    result.title = result.title()
  end

  -- If we don't have a title, then drop this command.
  if result.title == nil then
    return nil
  end

  -- Render the description if it's a function.
  if type(result.desc) == "function" then
    result.desc = result.desc()
  end

  -- Render the shortcut.
  result.shortcut = render_shortcut(result)

  return result
end

function M.get_commands()
  local results = {}

  for _, command in pairs(command_list) do
    command = render(command)

    if is_available(command) then
      table.insert(results, command)
    end
  end

  return results
end

return M
