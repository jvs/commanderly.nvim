local M = {}

M.commands = {}


local function create_command_name(title)
  local prefix = "Commanderly"

  -- Capitalize each word and the remove all spaces.
  local suffix = string.gsub(" " .. title, "%W%l", string.upper):gsub("%s+", "")

  return prefix .. suffix
end


local function add_command(command)
  -- Add the command to our table of all commands.
  table.insert(M.commands, command)

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
    "buffers",
    "integrations",
    "paths",
    "splits",
    "telescope",
  }

  for _, name in pairs(modules) do
    local module_name = "commanderly.commands." .. name
    M.add(require(module_name))
  end

  require("telescope").load_extension("commanderly")
end


function M.open(line1, line2)
  vim.cmd("Telescope commanderly")
end


return M
