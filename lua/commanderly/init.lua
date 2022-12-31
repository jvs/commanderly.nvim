local M = {}

-- A map of labels to commands.
local command_index = {}

-- A list of all the globally-registered commands.
local command_list = {}


local function create_key(s)
  return s:gsub("[^a-zA-Z0-9_]", "_"):lower()
end


local function add_command(command)
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
    local run = function() M.run(command) end
    local opts = vim.deepcopy(command.opts or {})

    if opts.desc == nil then
      opts.desc = command.desc
    end

    vim.keymap.set(command.mode, command.keymapping, run, opts)
  end
end


function M.add_commands(commands)
  if commands.title ~= nil or commands.id ~= nill then
    add_command(commands)
  else
    for _, command in pairs(commands) do
      add_command(command)
    end
  end
end


function M.map(keys, command, opts)
  opts = opts or {}

  local mode = opts.mode

  if mode == nil and type(command) == "table" then
    mode = command.mode
  end

  if mode == nil then
    mode = "n"
  end

  local run = function() M.run(command) end
  vim.keymap.set(mode, keys, run, opts)
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
  vim.cmd("Telescope commanderly")
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
  if command == nil then
    return false

  elseif command.hidden then
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


local function render(command)
  if type(command.render) == "function" then
    command = command.render()
  end

  local result = vim.deepcopy(command)

  if type(result.title) == "function" then
    result.title = result.title()
  end

  if result.title == nil then
    return nil
  end

  if type(result.desc) == "function" then
    result.desc = result.desc()
  end

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
