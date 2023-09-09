local library = require("commanderly.library")

local M = {}

-- The previous command run by Commanderly.
local previous_command = nil

-- The mode and the selection when Commanderly was opened.
local initial_mode = nil
local initial_selection = nil


-- Indicates if the provided mode is a visual mode.
local function is_visual_mode(mode)
  return mode == "v" or mode == "V" or mode == "\22"
end

-- Returns the current mode as a string.
local function get_mode()
  return vim.api.nvim_get_mode().mode
end

local function has_requirement(requirement)
  -- A requirement can be a string, a function, a table, or nil.
  if requirement == nil then
    return true
  end

  -- If it's a string, then interpret it as the name of a lua module.
  if type(requirement) == "string" then
    local is_ok, _ = pcall(require, requirement)
    return is_ok
  end

  -- If it's a function, then treat it as a boolean-valued function.
  if type(requirement) == "function" then
    return requirement()
  end

  -- If it's a table, then treat it as a list of requirements.
  if type(requirement) == "table" then
    for _, item in pairs(requirement) do
      if not has_requirement(item) then
        return false
      end
    end
    return true
  end

  error("Unexpected requirement: " .. type(requirement))
end

function M.record_initial_state()
  initial_mode = get_mode()

  if is_visual_mode(initial_mode) then
    initial_selection = { v = vim.fn.getpos('v'), cursor = vim.fn.getcurpos() }
  else
    initial_selection = nil
  end
end

function M.is_available(command)
  -- Is this command invalid or hidden?
  if command == nil or command.title == nil or command.hidden then
    return false
  end

  -- Can we satisfy its requirements?
  if not has_requirement(command.requires) then
    return false
  end

  -- Does this command require a specific mode?
  local modes = command.modes or command.mode

  -- Normalize the command's "modes" setting.
  if type(modes) == "string" then
    modes = { modes }
  end

  -- If the command doesn't specify any modes, then it's always available.
  if modes == nil then
    return true
  end

  -- Otherwise, see if the command's mode works with our intial mode.
  for _, mode in ipairs(modes) do
    local mode_matches = (
        (mode == initial_mode)
            or (mode == "normal" and initial_mode == "n")
            or (mode == "visual" and is_visual_mode(initial_mode))
        )
    if mode_matches then
      return true
    end
  end

  -- We couldn't find a match, so don't make this command available.
  return false
end

function M.run(command)
  local original_command = command

  if type(command) == "string" then
    command = library.get_command_or_fail(command)
  end

  -- If this is the special "commanderly_repeat" command, then repeat the last
  -- command (or exit if we don't have one yet).
  if command.id == "commanderly_repeat" then
    if previous_command ~= nil then
      M.run(previous_command)
    end
    return
  end

  if initial_selection ~= nil and not is_visual_mode(get_mode()) then
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

return M
