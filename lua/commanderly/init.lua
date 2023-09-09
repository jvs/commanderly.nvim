local M = {}

-- A map of labels to commands.
local command_index = {}

-- A list of all the globally-registered commands.
local command_list = {}

-- A table of all the keymappings.
local keymappings = {}

local previous_command = nil

local initial_mode = nil
local initial_selection = nil

local function is_visual_mode(mode)
  return mode == "v" or mode == "V" or mode == "\22"
end

local function in_visual_mode()
  local modeInfo = vim.api.nvim_get_mode()
  return is_visual_mode(modeInfo.mode)
end

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

function M.define_command(name, command, opts)
  opts = vim.deepcopy(opts or {})

  if opts.desc == nil then
    local command_info
    if type(command) == "string" then
      command_info = M.get_command(command)
    else
      command_info = command
    end

    if command_info ~= nil then
      opts.desc = command_info.desc
    end
  end

  local run = function()
    M.run(command)
  end

  vim.api.nvim_create_user_command(name, run, opts)
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
  local original_command = command

  if type(command) == "string" then
    command = get_command_or_fail(command)
  end

  -- If this is the special "commanderly_repeat" command, then repeat the last
  -- command (or exit if we don't have one yet).
  if command.id == "commanderly_repeat" then
    if previous_command ~= nil then
      M.run(previous_command)
    end
    return
  end

  if initial_selection ~= nil and not in_visual_mode() then
    -- Return the cursor to the start of the selection.
    vim.fn.setpos('.', initial_selection.v)

    -- Return to our initial mode.
    vim.api.nvim_feedkeys(initial_mode, "n", false)

    -- Move the cursor back to where it was.
    vim.schedule_wrap(vim.fn.setpos)('.', initial_selection.cursor)

    -- Run the command again (but this time we'll be in a visual mode).
    vim.schedule_wrap(M.run)(command)
    return
  end

  -- Update our global variable tracking the previous command.
  previous_command = original_command

  local run = command.run

  if type(run) == "function" then
    run()
  elseif type(run) == "string" then
    vim.cmd(run)
  elseif type(run) == "table" then
    local keys = vim.api.nvim_replace_termcodes(run.keys, true, false, true)
    vim.api.nvim_feedkeys(keys, run.mode or "n", false)
  else
    error('Invalid command. Received: ' .. vim.inspect(command))
  end
end

local function load_default_commands()
  local modules = {
    "core",
    "integrations",
    "telescope",
  }

  for _, name in pairs(modules) do
    local module_name = "commanderly.commands." .. name
    M.add_commands(require(module_name))
  end
end

function M.setup(opts)
  if vim.g.loaded_commanderly_commands ~= 1 then
    load_default_commands()
    vim.g.loaded_commanderly_commands = 1
  end

  require("telescope").load_extension("commanderly")
end

function M.open()
  local modeInfo = vim.api.nvim_get_mode()
  initial_mode = modeInfo.mode

  if is_visual_mode(initial_mode) then
    initial_selection = {v = vim.fn.getpos('v'), cursor = vim.fn.getcurpos()}
  else
    initial_selection = nil
  end

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
  elseif type(command.run) == "string" then
    local head = command.run:gsub("%s.*", "")
    local has_command = vim.fn.exists(":" .. head) > 0

    if not has_command then
      return false
    end
  end

  -- If the command doesn't specify any modes, then it's always available.
  if command.modes == nil then
    return true
  end

  -- Otherwise, see if the command's mode works with our intial mode.
  for _, mode in ipairs(command.modes) do
    if (
      (mode == initial_mode)
      or (mode == "visual" and is_visual_mode(initial_mode))
      or (mode == "normal" and initial_mode == "n")
    ) then
      return true
    end
  end

  -- We couldn't find a match, so don't make this command available.
  return false
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

local function render_command_string(s)
  local wincmd = "wincmd "
  if s:sub(1, string.len(wincmd)) == wincmd then
    return "ctrl+w,ctrl+" .. s:sub(string.len(wincmd) + 1)
  else
    return ":" .. s
  end
end

local function render_shortcut(command)
  local shortcut = render_keymapping(command.keymapping)

  if shortcut ~= nil then
    return shortcut
  elseif type(command.run) == "string" then
    return render_command_string(command.run)
  elseif type(command.run) == "table" then
    return command.run.keys
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
