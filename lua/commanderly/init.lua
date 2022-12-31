local M = {}

M.commands = {}


local function create_command_name(title)
  local prefix = "Commanderly"

  -- Capitalize each word and the remove all spaces.
  local suffix = string.gsub(" " .. title, "%W%l", string.upper):gsub("%W+", "")

  return prefix .. suffix
end


local function add_command(command)
  -- Add the command to our table of all commands.
  table.insert(M.commands, command)

  if command.title == nil or type(command.title) == "function" then
    return
  end

  local name = create_command_name(command.title)
  local run = function() M.run(command) end
  local opts = {}

  if command.desc ~= nil then
    opts["desc"] = command.desc
  end

  -- Create a user command.
  vim.api.nvim_create_user_command(name, run, opts)

  -- Optionally create a keymapping.
  if command.mode ~= nil then
    local lhs = command.mapping

    if lhs == nil then
      lhs = "<Plug>(" .. name .. ")"
    end

    vim.keymap.set(command.mode, lhs, run, opts)
  end
end


function M.add(commands)
  if commands.title ~= nil then
    add_command(commands)
  else
    for _, command in pairs(commands) do
      add_command(command)
    end
  end
end


function M.run(command)
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
    M.add(require(module_name))
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

  if type(result.desc) == "function" then
    result.desc = result.desc()
  end

  return result
end


function M.get_commands()
  local results = {}
  for _, command in pairs(M.commands) do
    command = render(command)

    if is_available(command) then
      table.insert(results, command)
    end
  end

  return results
end


return M
