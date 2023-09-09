local M = {}

local function render_command_string(s)
  local wincmd = "wincmd "
  if s:sub(1, string.len(wincmd)) == wincmd then
    return "ctrl+w,ctrl+" .. s:sub(string.len(wincmd) + 1)
  else
    return ":" .. s
  end
end

-- Takes a command and returns an array of shortcuts.
local function render_shortcuts(command)
  local result = {}

  if type(command.run) == "string" then
    table.insert(result, render_command_string(command.run))
  end

  if type(command.run) == "table" then
    table.insert(result, command.run.keys)
  end

  if type(command._keymappings) == "table" then
    for _, keys in ipairs(command._keymappings) do
      table.insert(result, keys)
    end
  end

  return result
end

-- Takes a list of shortcuts and returns one of the shortest ones.
local function get_shortest_shortcut(shortcuts)
  local result = nil

  for _, shortcut in ipairs(shortcuts) do
    if result == nil or #result >= #shortcut then
      result = shortcut
    end
  end

  return result
end

function M.render(command)
  local result = nil

  -- Call the command's render function. Create a deepcopy so that we don't
  -- mutate the actual command table.
  if type(command.render) == "function" then
    result = vim.deepcopy(command.render())

    -- Copy any missing fields from the original command.
    for k, v in pairs(command) do
      if k ~= "render" and result[k] == nil then
        result[k] = v
      end
    end
  else
    result = vim.deepcopy(command)
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

  -- List all the shortcuts.
  result._shortcuts = render_shortcuts(result)

  -- Pick the shortest the shortcut.
  result.shortcut = get_shortest_shortcut(result._shortcuts)

  return result
end

return M
