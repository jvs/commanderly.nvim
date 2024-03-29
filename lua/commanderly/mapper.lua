local library = require("commanderly.library")
local runner = require("commanderly.runner")

local M = {}

-- Map the key sequence to the indicated command.
function M.map(keys, command_code, opts)
  -- Validate the command_code argument.
  if type(command_code) ~= "string" then
    print("Type error: expected string, received " .. type(command_code) .. ".")
    return
  end

  -- Look up the command using the command code (either the command's id or title).
  local command = library.get_command_or_fail(command_code)

  -- Pull out the mode from the opts.
  opts = vim.deepcopy(opts or {})
  local mode = opts.mode

  if mode ~= nil then
    opts.mode = nil
  end

  -- Infer the mode from the command's mode.
  if mode == nil and type(command.mode) == "string" then
    mode = string.sub(command.mode, 1, 1)
  end

  if mode == nil and type(command.mode) == "table" then
    mode = command.mode
  end

  -- If all else fails, then use normal mode as the default.
  if mode == nil then
    mode = "n"
  end

  -- Use the command's desc if we don't have one for this mapping.
  if opts.desc == nil then
    opts.desc = command.desc
  end

  -- Create a function for vim to call.
  local run = function()
    runner.run(command_code)
  end

  -- Register the keymapping with vim.
  local function set_keymap()
    vim.keymap.set(mode, keys, run, opts)
  end

  local ok, err = pcall(set_keymap)
  if not ok then
    print("Failed to map " .. keys .. " to " .. command_code .. ".")
    print(err)
    return
  end

  -- Update the command to include this keymapping.
  if command._keymappings == nil then
    command._keymappings = {}
  end
  table.insert(command._keymappings, keys)
end

return M
